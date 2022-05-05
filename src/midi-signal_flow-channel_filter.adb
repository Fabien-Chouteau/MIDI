package body MIDI.Signal_Flow.Channel_Filter is

   ------------
   -- Create --
   ------------

   function Create return Any_Node_Acc is
   begin
      return new Node;
   end Create;

   -------------
   -- Receive --
   -------------

   overriding
   procedure Receive (This : in out Node; Port : Port_Id; Msg : Message) is
   begin
      --  TODO: Filter property here...
      if Msg.Kind /= Sys and then Msg.Chan = 1 then
         This.Send (1, Msg);
      else
         This.Send (2, Msg);
      end if;
   end Receive;

end MIDI.Signal_Flow.Channel_Filter;
