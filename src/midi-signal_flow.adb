package body MIDI.Signal_Flow is

   subtype Dispatch is Node'Class;

   -------------
   -- Connect --
   -------------

   procedure Connect (This     : in out   Node;
                      L        : not null Any_Link_Acc;
                      Kind     :          Port_Kind;
                      Org_Port :          Port_Id;
                      Target   : not null Any_Node_Acc;
                      Tar_Port :          Port_Id)
   is
   begin
      if Dispatch (This).Out_Port_Info (Org_Port).Kind = Kind
        and then
         Target.In_Port_Info (Tar_Port).Kind = Kind
      then
         L.Kind := Kind;
         L.Org_Port := Org_Port;
         L.Target := Target;
         L.Target_Port := Tar_Port;
         L.Next := This.Output_Links;
         This.Output_Links := L;
      end if;
   end Connect;

   ----------
   -- Send --
   ----------

   procedure Send (This : Node; Port : Port_Id; Msg : Message) is
      L : Any_Link_Acc := This.Output_Links;
   begin
      while L /= null loop

         if L.Org_Port = Port
           and then
            L.Kind in Cable_Link | Channel_Link
           and then
            L.Target /= null
         then
            L.Target.Receive (L.Target_Port, Msg);
         end if;

         L := L.Next;
      end loop;
   end Send;

   ----------
   -- Send --
   ----------

   procedure Send (This : Node; Port : Port_Id; Data : MIDI_Data) is
      L : Any_Link_Acc := This.Output_Links;
   begin
      while L /= null loop

         if L.Org_Port = Port
           and then
            L.Kind in Data_Link
           and then
            L.Target /= null
         then
            L.Target.Receive (L.Target_Port, Data);
         end if;

         L := L.Next;
      end loop;
   end Send;

end MIDI.Signal_Flow;
