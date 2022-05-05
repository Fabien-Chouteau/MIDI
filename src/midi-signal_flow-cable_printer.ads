package MIDI.Signal_Flow.Cable_Printer is

   subtype Parent is MIDI.Signal_Flow.Node;
   type Node
   is new Parent with
   private;

   type Any_Node_Acc is access all Node'Class;

   function Create return Any_Node_Acc;

   overriding
   function Category (This : Node) return Category_Kind
   is (Cable);

   overriding
   function Name (This : Node) return String
   is ("printer");

   overriding
   function Out_Port_Info (This : Node;
                           Port : Port_Id)
                           return Port_Info
   is (Invalid_Port);
   --  No outputs

   overriding
   function In_Port_Info (This : Node;
                          Port : Port_Id)
                          return Port_Info
   is (case Port is
       when 1 =>  (Cable_Link, "In             "),
       when others => Invalid_Port);

   overriding
   function Get_Property_Info (This : Node; Prop : Property_Id)
                               return Property_Info
   is (Invalid_Property);

   overriding
   procedure Receive (This : in out Node;
                      Port :        Port_Id;
                      Data :        MIDI_Data)
   is null;
   --  This node doesn't receive MIDI_Data

   overriding
   procedure Receive (This : in out Node;
                      Port :        Port_Id;
                      Msg  :        Message);

private

   type Node
   is new Parent
     with null record;

end MIDI.Signal_Flow.Cable_Printer;
