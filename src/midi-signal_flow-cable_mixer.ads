package MIDI.Signal_Flow.Cable_Mixer is

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
   is ("mixer");

   overriding
   function Out_Port_Info (This : Node; Port : Port_Id) return Port_Info
   is (case Port is
          when 1 => (Cable_Link, "In             "),
          when others => Invalid_Port);
   --  Only one output Cable_Link

   overriding
   function In_Port_Info (This : Node; Port : Port_Id) return Port_Info;

   overriding
   function Get_Property_Info (This : Node; Prop : Property_Id)
                               return Property_Info
   is (case Prop is
          when 1      => (Mixer_Inputs_Prop, "input_count    ", Default => 2),
          when others => Invalid_Property);

   overriding
   procedure Set_Property (This : in out Node;
                           Key  :        String;
                           Val  :        Integer);

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
   is new Parent with record
      Input_Count : Integer := 2;
   end record;

end MIDI.Signal_Flow.Cable_Mixer;
