with Ada.Text_IO; use Ada.Text_IO;

package body MIDI.Signal_Flow.LiteGraph is

   -----------
   -- Strip --
   -----------

   function Strip (Str : Port_Label) return String is
      Last : Natural := Str'Last;
   begin
      while Last in Str'Range and then Str (Last) = ' ' loop
         Last := Last - 1;
      end loop;
      return String (Str (Str'First .. Last));
   end Strip;

   -----------
   -- Strip --
   -----------

   function Strip (Str : Property_Label) return String is
      Last : Natural := Str'Last;
   begin
      while Last in Str'Range and then Str (Last) = ' ' loop
         Last := Last - 1;
      end loop;
      return String (Str (Str'First .. Last));
   end Strip;

   --------------------
   -- Shape_For_Port --
   --------------------

   function Shape_For_Port (Kind : Port_Kind) return String
   is  (case Kind is
           when Invalid      => "",
           when Data_Link    => "ROUND_SHAPE",
           when Channel_Link => "ARROW_SHAPE",
           when Cable_Link   => "BOX_SHAPE");

   --------------------
   -- Print_Port_Def --
   --------------------

   procedure Print_Port_Def (This     : Node'Class;
                             Info     : Port_Info;
                             Is_Input : Boolean)
   is
      pragma Unreferenced (This);

      Label    : constant String := Strip (Info.Label);
      Type_Str : constant String := Info.Kind'Img;
      Shape    : constant String := Shape_For_Port (Info.Kind);

      Func : constant String := (if Is_Input then "addInput" else "addOutput");
   begin

      if Info.Kind /= Invalid then

         Put_Line ("  this." & Func & "(""" &
                     Label
                   & """, """ &
                     Type_Str
                   & """, {shape: LiteGraph." & Shape & "});");
      end if;
   end Print_Port_Def;

   --------------------
   -- Print_Property --
   --------------------

   procedure Print_Property (This : Node'Class; Info : Property_Info) is
      Label    : constant String := Strip (Info.Label);
   begin
      Put_Line ("  this.properties[""" & Label & """] = " &
                  Info.Default'Img & ";");

      case Info.Kind is
         when Mixer_Inputs_Prop =>
            Put_Line ("  this.addWidget(""button"",""+"",null,function(){");

            declare
               P_Info : constant Port_Info := This.In_Port_Info (1);
               Label    : constant String := Strip (P_Info.Label);
               Shape : constant String := Shape_For_Port (P_Info.Kind);
            begin
               Put_Line ("          that.addInput(""" &
                           Label
                         & """, """ &
                           P_Info.Kind'Img
                         & """, {shape: LiteGraph." & Shape & "});");
            end;
            Put_Line ("          that.properties." & Label & " += 1;");
            Put_Line ("      });");

         when Channel_Prop =>

            Put_Line ("  this.addWidget(""combo"", """ & Label &
                        """, " & Info.Default'Img & ", null,");
            Put_Line ("             { values:[1, 2, 3, 4, 5, 6, 7, 8, 9, 10," &
                        " 11, 12, 13, 14, 15, 16],");
            Put_Line ("               property: """ & Label & """});");

         when others =>

            null; -- raise Program_Error;
      end case;
   end Print_Property;

   ----------------------
   -- Print_Definition --
   ----------------------

   procedure Print_Definition (This : Node'Class) is

      Name : constant String := This.Name;
      Cat  : constant String := This.Category'Img;
      LG_Node_Name : constant String := "Node_" & Cat & "_" & Name;

   begin
      Put_Line ("function " & LG_Node_Name & "()");
      Put_Line ("{");
      Put_Line ("  that = this;");

      for X in 1 .. Port_Id'Last loop
         declare
            Info : constant Port_Info := This.In_Port_Info (X);
         begin

            exit when Info.Kind = Invalid;

            Print_Port_Def (This, Info, Is_Input => True);
         end;
      end loop;

      for X in 1 .. Port_Id'Last loop
         declare
            Info : constant Port_Info := This.Out_Port_Info (X);
         begin

            exit when Info.Kind = Invalid;

            Print_Port_Def (This, Info, Is_Input => False);
         end;
      end loop;

      Put_Line ("  this.properties = {};");
      for X in 1 .. Property_Id'Last loop
         declare
            Info : constant Property_Info := This.Get_Property_Info (X);
         begin
            exit when Info.Kind = Invalid;
            Print_Property (This, Info);
         end;
      end loop;

         Put_Line ("}");
      Put_Line (LG_Node_Name & ".title = """ & Name & """;");

      Put_Line ("LiteGraph.registerNodeType(""" & Cat & "/" & Name & """, " &
                  LG_Node_Name & ");");
   end Print_Definition;

end MIDI.Signal_Flow.LiteGraph;
