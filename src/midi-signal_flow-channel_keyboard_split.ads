package MIDI.Signal_Flow.Channel_Keyboard_Split is

   subtype Parent is MIDI.Signal_Flow.Node;
   type Node
   is new Parent with
   private;

   type Any_Node_Acc is access all Node'Class;

   function Create return Any_Node_Acc;

   overriding
   function Category (This : Node) return Category_Kind
   is (Channel);

   overriding
   function Name (This : Node) return String
   is ("keyboard_split");

   overriding
   function In_Port_Info (This : Node;
                          Port : Port_Id)
                          return Port_Info
   is (case Port is
          when 1 => (Data_Link,    "Split Key      "),
          when 2 => (Channel_Link, "Channel        "),
          when others => Invalid_Port);

   overriding
   function Out_Port_Info (This : Node;
                           Port : Port_Id)
                           return Port_Info
   is (case Port is
          when 1 => (Channel_Link, "High Channel   "),
          when 2 => (Channel_Link, "Low Channel    "),
          when others => Invalid_Port);
   overriding
   function Get_Property_Info (This : Node; Prop : Property_Id)
                               return Property_Info
   is (case Prop is
          when 1 => (Key_Prop,     "split_key      ", Default => 60),
          when 2 => (Channel_Prop, "high_channel_id", Default => 1),
          when 3 => (Channel_Prop, "low_channel_id ", Default => 2),
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
   is new Parent
   with record
      Split_Key : MIDI_Key := 60;
      High_Chan : MIDI_Channel := 0;
      Low_Chan  : MIDI_Channel := 1;
   end record;

end MIDI.Signal_Flow.Channel_Keyboard_Split;
