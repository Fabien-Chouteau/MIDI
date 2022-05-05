with AUnit; use AUnit;
with AUnit.Test_Suites;
with AUnit.Run;
with AUnit.Reporter.Text;

with GNAT.OS_Lib;

with Testsuite.Decode;
with Testsuite.Encode;

with MIDI.Signal_Flow;
with MIDI.Signal_Flow.Cable_Mixer;
with MIDI.Signal_Flow.Cable_Printer;
with MIDI.Signal_Flow.Channel_Filter;
with MIDI.Signal_Flow.Channel_Printer;
with MIDI.Signal_Flow.Channel_Keyboard_Split;
with MIDI.Signal_Flow.LiteGraph;

procedure Tests is
   Failures : Natural := 0;
begin

   declare
      Suite : aliased AUnit.Test_Suites.Test_Suite;

      function Get_Suite return AUnit.Test_Suites.Access_Test_Suite
      is (Suite'Unchecked_Access);

      function Runner is new AUnit.Run.Test_Runner_With_Status (Get_Suite);

      Reporter : AUnit.Reporter.Text.Text_Reporter;
   begin
      Testsuite.Decode.Add_Tests (Suite);
      Testsuite.Encode.Add_Tests (Suite);

      Reporter.Set_Use_ANSI_Colors (True);

      if Runner (Reporter,
                 (Global_Timer     => True,
                  Test_Case_Timer  => True,
                  Report_Successes => True,
                  others           => <>))
        /= AUnit.Success
      then
         Failures := Failures + 1;
      end if;
   end;

   if Failures /= 0 then
      GNAT.OS_Lib.OS_Exit (1);
   end if;

   declare
      use MIDI.Signal_Flow;
      use MIDI;

      Mix1  : constant Cable_Mixer.Any_Node_Acc := Cable_Mixer.Create;
      Mix2  : constant Cable_Mixer.Any_Node_Acc := Cable_Mixer.Create;
      Filter : constant Channel_Filter.Any_Node_Acc := Channel_Filter.Create;
      Print_Cable : constant Cable_Printer.Any_Node_Acc :=
        Cable_Printer.Create;
      Print_Chan : constant Channel_Printer.Any_Node_Acc :=
        Channel_Printer.Create;

      Split  : constant Channel_Keyboard_Split.Any_Node_Acc :=
        Channel_Keyboard_Split.Create;

   begin
      Mix1.Connect (new Link, Cable_Link, 1, Any_Node_Acc (Filter), 1);
      Filter.Connect (new Link, Cable_Link, 2, Any_Node_Acc (Mix2), 1);
      Filter.Connect (new Link, Channel_Link, 1, Any_Node_Acc (Print_Chan), 1);
      Filter.Connect (new Link, Channel_Link, 1, Any_Node_Acc (Split), 1);
      Mix2.Connect (new Link, Cable_Link, 1, Any_Node_Acc (Print_Cable), 1);

      Mix1.Receive (1, (Kind => Note_On,
                        Chan => 2,
                        Key => 2,
                        Velocity => 3));
      Mix1.Receive (1, (Kind => Note_On,
                        Chan => 1,
                        Key => 2,
                        Velocity => 3));
      Mix1.Receive (1, (Kind => Note_On,
                        Chan => 2,
                        Key => 2,
                        Velocity => 3));

      LiteGraph.Print_Definition (Mix1.all);
      LiteGraph.Print_Definition (Print_Chan.all);
      LiteGraph.Print_Definition (Print_Cable.all);
      LiteGraph.Print_Definition (Filter.all);
      LiteGraph.Print_Definition (Split.all);
   end;

end Tests;
