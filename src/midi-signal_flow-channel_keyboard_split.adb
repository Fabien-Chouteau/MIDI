with HAL;

package body MIDI.Signal_Flow.Channel_Keyboard_Split is

   ------------
   -- Create --
   ------------

   function Create return Any_Node_Acc is
   begin
      return new Node;
   end Create;

   ------------------
   -- Set_Property --
   ------------------

   overriding
   procedure Set_Property (This : in out Node; Key : String; Val : Integer)
   is
   begin
      raise Program_Error with "Unimplemented procedure Set_Property";
   end Set_Property;

   -------------
   -- Receive --
   -------------

   overriding
   procedure Receive (This : in out Node; Port : Port_Id; Msg : Message) is
      use type HAL.UInt8;
   begin
      case Msg.Kind is
         when Note_On | Note_Off | Aftertouch =>
            --  Send to either output depending on the key
            if Msg.Key >= This.Split_Key then
               This.Send (1, Msg);
            else
               This.Send (2, Msg);
            end if;

         when others =>
            --  Any other message is broadcasted to both outputs
            This.Send (1, Msg);
            This.Send (2, Msg);
      end case;
   end Receive;

end MIDI.Signal_Flow.Channel_Keyboard_Split;
