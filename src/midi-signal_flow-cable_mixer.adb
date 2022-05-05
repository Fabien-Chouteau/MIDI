package body MIDI.Signal_Flow.Cable_Mixer is

   ------------
   -- Create --
   ------------

   function Create return Any_Node_Acc
   is (new Node);

   overriding
   function In_Port_Info (This : Node; Port : Port_Id) return Port_Info is
   begin

      if Port in  1 .. Port_Id (This.Input_Count) then
         return (Cable_Link, "In             ");
      else
         return Invalid_Port;
      end if;
   end In_Port_Info;

   ------------------
   -- Set_Property --
   ------------------

   overriding
   procedure Set_Property (This : in out Node;
                           Key  :        String;
                           Val  :        Integer)
   is
   begin
      if Key = "input_count" and then Val > 0 then
         This.Input_Count := Val;
      end if;
   end Set_Property;

   -------------
   -- Receive --
   -------------

   overriding
   procedure Receive (This : in out Node;
                      Port : Port_Id;
                      Msg  : Message)
   is
   begin
      --  Transfer any input to the mixer output
      This.Send (1, Msg);
   end Receive;

end MIDI.Signal_Flow.Cable_Mixer;
