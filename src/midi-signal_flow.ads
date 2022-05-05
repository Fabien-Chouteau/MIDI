package MIDI.Signal_Flow is

   type Port_Kind is (Invalid, Data_Link, Channel_Link, Cable_Link);
   type Port_Id is new Natural;
   type Port_Label is new String (1 .. 15);
   type Port_Info is record
      Kind  : Port_Kind;
      Label : Port_Label;
   end record;

   Invalid_Port : constant Port_Info := (Invalid, (others => <>));

   type Property_Kind is (Invalid, Key_Prop, Data_Prop, Channel_Prop,
                          Mixer_Inputs_Prop);
   type Property_Id is new Natural;
   type Property_Label is new String (1 .. 15);
   type Property_Info is record
      Kind    : Property_Kind;
      Label   : Property_Label;
      Default : Integer;
   end record;

   Invalid_Property : constant Property_Info := (Invalid, others => <>);

   type Category_Kind is (Utils, Cable, Channel, Data);

   type Node
   is abstract tagged limited
   private;

   type Any_Node_Acc is access all Node'Class;

   function Category (This : Node) return Category_Kind
   is abstract;

   function Name (This : Node) return String
   is abstract;

   function Out_Port_Info (This : Node;
                           Port : Port_Id)
                           return Port_Info
                           is abstract;

   function In_Port_Info (This : Node;
                          Port : Port_Id)
                          return Port_Info
                          is abstract;

   function Get_Property_Info (This : Node;
                               Prop : Property_Id)
                               return Property_Info
   is abstract;

   procedure Set_Property (This : in out Node;
                           Key  :        String;
                           Val  :        Integer)
   is null;

   type Link is private;
   type Any_Link_Acc is access all Link;

   procedure Connect (This     : in out   Node;
                      L        : not null Any_Link_Acc;
                      Kind     :          Port_Kind;
                      Org_Port :          Port_Id;
                      Target   : not null Any_Node_Acc;
                      Tar_Port :          Port_Id);

   procedure Send (This : Node;
                   Port : Port_Id;
                   Msg  : Message)
     with Pre'Class =>
       Out_Port_Info (Node'Class (This), Port).Kind
         in Cable_Link | Channel_Link;

   procedure Send (This : Node;
                   Port : Port_Id;
                   Data : MIDI_Data)
   with Pre'Class => Out_Port_Info (Node'Class (This), Port).Kind = Data_Link;

   procedure Receive (This : in out Node;
                      Port :        Port_Id;
                      Data :        MIDI_Data)
   is abstract
     with Pre'Class => In_Port_Info (Node'Class (This), Port).Kind = Data_Link;

   procedure Receive (This : in out Node;
                      Port :        Port_Id;
                      Msg  :        Message)
   is abstract
     with Pre'Class =>
       In_Port_Info (Node'Class (This), Port).Kind
         in Cable_Link | Channel_Link;

private

   type Link is record
      Kind        : Port_Kind;
      Org_Port    : Port_Id;
      Target      : Any_Node_Acc;
      Target_Port : Port_Id;
      Next        : Any_Link_Acc := null;
   end record;

   type Node
   is abstract tagged limited
           record
              Output_Links : Any_Link_Acc := null;
           end record;

end MIDI.Signal_Flow;
