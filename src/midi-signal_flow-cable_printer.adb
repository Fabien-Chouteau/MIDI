with Ada.Text_IO;

package body MIDI.Signal_Flow.Cable_Printer is

   ------------
   -- Create --
   ------------

   function Create return Any_Node_Acc
   is (new Node);

   -------------
   -- Receive --
   -------------

   overriding
   procedure Receive (This : in out Node;
                      Port :        Port_Id;
                      Msg  :        Message)
   is
   begin
      Ada.Text_IO.Put_Line ("Cable: " & Img (Msg));
   end Receive;

end MIDI.Signal_Flow.Cable_Printer;
