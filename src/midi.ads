
--  This package provides types representing MIDI messages and data

package MIDI
with Preelaborate
is

   type Message_Kind is (Note_Off,
                         Note_On,
                         Aftertouch,
                         Continous_Controller,
                         Patch_Change,
                         Channel_Pressure,
                         Pitch_Bend,
                         Sys)
     with Size => 4;

   for Message_Kind use (Note_Off             => 16#8#,
                         Note_On              => 16#9#,
                         Aftertouch           => 16#A#,
                         Continous_Controller => 16#B#,
                         Patch_Change         => 16#C#,
                         Channel_Pressure     => 16#D#,
                         Pitch_Bend           => 16#E#,
                         Sys                  => 16#F#);

   type Sys_Command is (Exclusive,
                        Song_Position,
                        Song_Select,
                        Bus_Select,
                        Tune_Request,
                        End_Exclusive,
                        Timming_Tick,
                        Start_Song,
                        Continue_Song,
                        Stop_Song,
                        Active_Sensing,
                        Reset)
     with Size => 4;

   for Sys_Command use (Exclusive      => 16#0#,
                        Song_Position  => 16#2#,
                        Song_Select    => 16#3#,
                        Bus_Select     => 16#5#,
                        Tune_Request   => 16#6#,
                        End_Exclusive  => 16#7#,
                        Timming_Tick   => 16#8#,
                        Start_Song     => 16#A#,
                        Continue_Song  => 16#B#,
                        Stop_Song      => 16#C#,
                        Active_Sensing => 16#E#,
                        Reset          => 16#F#);

   type MIDI_UInt8 is mod 2**8 with Size => 8;
   subtype MIDI_Data is MIDI_UInt8 range 2#0000_0000# .. 2#0111_1111#;
   subtype MIDI_Key is MIDI_Data;
   type MIDI_Channel is mod 2**4 with Size => 4;

   type Message (Kind : Message_Kind := Note_On) is record
      case Kind is
         when Sys =>
            Cmd : Sys_Command;
            --  System messages can have 0, 1 or 2 data bytes. The kind of
            --  system message being in the "Cmd" nibble, we cannot use it
            --  for a case statement in this record. So we add two bytes
            --  here to cover all the cases.
            S1, S2 : MIDI_Data;
         when others =>
            Chan : MIDI_Channel;
            case Kind is
            when Note_On | Note_Off | Aftertouch =>
               Key      : MIDI_Key;
               Velocity : MIDI_Data;
            when Continous_Controller =>
               Controller       : MIDI_Data;
               Controller_Value : MIDI_Data;
            when Patch_Change =>
               Instrument : MIDI_Data;
            when Channel_Pressure =>
               Pressure : MIDI_Data;
            when Pitch_Bend =>
               Bend : MIDI_Data;
            when Sys =>
               null;
            end case;
      end case;
   end record
     with Size => 3 * 8;

   for Message use record
      Kind             at 0 range 4 .. 7;
      Cmd              at 0 range 0 .. 3;
      Chan             at 0 range 0 .. 3;
      Key              at 1 range 0 .. 7;
      Velocity         at 2 range 0 .. 7;
      Controller       at 1 range 0 .. 7;
      Controller_Value at 2 range 0 .. 7;
      Instrument       at 1 range 0 .. 7;
      Pressure         at 1 range 0 .. 7;
      Bend             at 1 range 0 .. 7;
      S1               at 1 range 0 .. 7;
      S2               at 2 range 0 .. 7;
   end record;

   function Img (Msg : Message) return String;

   type Octaves is new MIDI_UInt8 range 1 .. 8;
   type Notes is (C, Cs, D, Ds, E, F, Fs, G, Gs, A, As, B);

   function Key (Oct : Octaves; N : Notes) return MIDI_Key
   is (MIDI_Key (12 + Natural (Oct) * 12 +
         Notes'Pos (N) - Notes'Pos (Notes'First)));

   A0  : constant MIDI_Key := 16#15#;
   As0 : constant MIDI_Key := 16#16#;
   B0  : constant MIDI_Key := 16#17#;
   C1  : constant MIDI_Key := 16#18#;
   Cs1 : constant MIDI_Key := 16#19#;
   D1  : constant MIDI_Key := 16#1a#;
   Ds1 : constant MIDI_Key := 16#1b#;
   E1  : constant MIDI_Key := 16#1c#;
   F1  : constant MIDI_Key := 16#1d#;
   Fs1 : constant MIDI_Key := 16#1e#;
   G1  : constant MIDI_Key := 16#1f#;
   Gs1 : constant MIDI_Key := 16#20#;
   A1  : constant MIDI_Key := 16#21#;
   As1 : constant MIDI_Key := 16#22#;
   B1  : constant MIDI_Key := 16#23#;
   C2  : constant MIDI_Key := 16#24#;
   Cs2 : constant MIDI_Key := 16#25#;
   D2  : constant MIDI_Key := 16#26#;
   Ds2 : constant MIDI_Key := 16#27#;
   E2  : constant MIDI_Key := 16#28#;
   F2  : constant MIDI_Key := 16#29#;
   Fs2 : constant MIDI_Key := 16#2a#;
   G2  : constant MIDI_Key := 16#2b#;
   Gs2 : constant MIDI_Key := 16#2c#;
   A2  : constant MIDI_Key := 16#2d#;
   As2 : constant MIDI_Key := 16#2e#;
   B2  : constant MIDI_Key := 16#2f#;
   C3  : constant MIDI_Key := 16#30#;
   Cs3 : constant MIDI_Key := 16#31#;
   D3  : constant MIDI_Key := 16#32#;
   Ds3 : constant MIDI_Key := 16#33#;
   E3  : constant MIDI_Key := 16#34#;
   F3  : constant MIDI_Key := 16#35#;
   Fs3 : constant MIDI_Key := 16#36#;
   G3  : constant MIDI_Key := 16#37#;
   Gs3 : constant MIDI_Key := 16#38#;
   A3  : constant MIDI_Key := 16#39#;
   As3 : constant MIDI_Key := 16#3a#;
   B3  : constant MIDI_Key := 16#3b#;
   C4  : constant MIDI_Key := 16#3c#;
   Cs4 : constant MIDI_Key := 16#3d#;
   D4  : constant MIDI_Key := 16#3e#;
   Ds4 : constant MIDI_Key := 16#3f#;
   E4  : constant MIDI_Key := 16#40#;
   F4  : constant MIDI_Key := 16#41#;
   Fs4 : constant MIDI_Key := 16#42#;
   G4  : constant MIDI_Key := 16#43#;
   Gs4 : constant MIDI_Key := 16#44#;
   A4  : constant MIDI_Key := 16#45#;
   As4 : constant MIDI_Key := 16#46#;
   B4  : constant MIDI_Key := 16#47#;
   C5  : constant MIDI_Key := 16#48#;
   Cs5 : constant MIDI_Key := 16#49#;
   D5  : constant MIDI_Key := 16#4a#;
   Ds5 : constant MIDI_Key := 16#4b#;
   E5  : constant MIDI_Key := 16#4c#;
   F5  : constant MIDI_Key := 16#4d#;
   Fs5 : constant MIDI_Key := 16#4e#;
   G5  : constant MIDI_Key := 16#4f#;
   Gs5 : constant MIDI_Key := 16#50#;
   A5  : constant MIDI_Key := 16#51#;
   As5 : constant MIDI_Key := 16#52#;
   B5  : constant MIDI_Key := 16#53#;
   C6  : constant MIDI_Key := 16#54#;
   Cs6 : constant MIDI_Key := 16#55#;
   D6  : constant MIDI_Key := 16#56#;
   Ds6 : constant MIDI_Key := 16#57#;
   E6  : constant MIDI_Key := 16#58#;
   F6  : constant MIDI_Key := 16#59#;
   Fs6 : constant MIDI_Key := 16#5a#;
   G6  : constant MIDI_Key := 16#5b#;
   Gs6 : constant MIDI_Key := 16#5c#;
   A6  : constant MIDI_Key := 16#5d#;
   As6 : constant MIDI_Key := 16#5e#;
   B6  : constant MIDI_Key := 16#5f#;
   C7  : constant MIDI_Key := 16#60#;
   Cs7 : constant MIDI_Key := 16#61#;
   D7  : constant MIDI_Key := 16#62#;
   Ds7 : constant MIDI_Key := 16#63#;
   E7  : constant MIDI_Key := 16#64#;
   F7  : constant MIDI_Key := 16#65#;
   Fs7 : constant MIDI_Key := 16#66#;
   G7  : constant MIDI_Key := 16#67#;
   Gs7 : constant MIDI_Key := 16#68#;
   A7  : constant MIDI_Key := 16#69#;
   As7 : constant MIDI_Key := 16#6a#;
   B7  : constant MIDI_Key := 16#6b#;
   C8  : constant MIDI_Key := 16#6c#;
   Cs8 : constant MIDI_Key := 16#6d#;
   D8  : constant MIDI_Key := 16#6e#;
   Ds8 : constant MIDI_Key := 16#6f#;
   E8  : constant MIDI_Key := 16#70#;
   F8  : constant MIDI_Key := 16#71#;
   Fs8 : constant MIDI_Key := 16#72#;
   G8  : constant MIDI_Key := 16#73#;
   Gs8 : constant MIDI_Key := 16#74#;
   A8  : constant MIDI_Key := 16#75#;
   As8 : constant MIDI_Key := 16#76#;
   B8  : constant MIDI_Key := 16#77#;

   Key_To_Frequency : constant array (MIDI.MIDI_Key) of Float :=
     (0   => 8.1757989156,
      1   => 8.6619572180,
      2   => 9.1770239974,
      3   => 9.7227182413,
      4   => 10.3008611535,
      5   => 10.9133822323,
      6   => 11.5623257097,
      7   => 12.2498573744,
      8   => 12.9782717994,
      9   => 13.7500000000,
      10  => 14.5676175474,
      11  => 15.4338531643,
      12  => 16.3515978313,
      13  => 17.3239144361,
      14  => 18.3540479948,
      15  => 19.4454364826,
      16  => 20.6017223071,
      17  => 21.8267644646,
      18  => 23.1246514195,
      19  => 24.4997147489,
      20  => 25.9565435987,
      21  => 27.5000000000,
      22  => 29.1352350949,
      23  => 30.8677063285,
      24  => 32.7031956626,
      25  => 34.6478288721,
      26  => 36.7080959897,
      27  => 38.8908729653,
      28  => 41.2034446141,
      29  => 43.6535289291,
      30  => 46.2493028390,
      31  => 48.9994294977,
      32  => 51.9130871975,
      33  => 55.0000000000,
      34  => 58.2704701898,
      35  => 61.7354126570,
      36  => 65.4063913251,
      37  => 69.2956577442,
      38  => 73.4161919794,
      39  => 77.7817459305,
      40  => 82.4068892282,
      41  => 87.3070578583,
      42  => 92.4986056779,
      43  => 97.9988589954,
      44  => 103.8261743950,
      45  => 110.0000000000,
      46  => 116.5409403795,
      47  => 123.4708253140,
      48  => 130.8127826503,
      49  => 138.5913154884,
      50  => 146.8323839587,
      51  => 155.5634918610,
      52  => 164.8137784564,
      53  => 174.6141157165,
      54  => 184.9972113558,
      55  => 195.9977179909,
      56  => 207.6523487900,
      57  => 220.0000000000,
      58  => 233.0818807590,
      59  => 246.9416506281,
      60  => 261.6255653006,
      61  => 277.1826309769,
      62  => 293.6647679174,
      63  => 311.1269837221,
      64  => 329.6275569129,
      65  => 349.2282314330,
      66  => 369.9944227116,
      67  => 391.9954359817,
      68  => 415.3046975799,
      69  => 440.0000000000,
      70  => 466.1637615181,
      71  => 493.8833012561,
      72  => 523.2511306012,
      73  => 554.3652619537,
      74  => 587.3295358348,
      75  => 622.2539674442,
      76  => 659.2551138257,
      77  => 698.4564628660,
      78  => 739.9888454233,
      79  => 783.9908719635,
      80  => 830.6093951599,
      81  => 880.0000000000,
      82  => 932.3275230362,
      83  => 987.7666025122,
      84  => 1046.5022612024,
      85  => 1108.7305239075,
      86  => 1174.6590716696,
      87  => 1244.5079348883,
      88  => 1318.5102276515,
      89  => 1396.9129257320,
      90  => 1479.9776908465,
      91  => 1567.9817439270,
      92  => 1661.2187903198,
      93  => 1760.0000000000,
      94  => 1864.6550460724,
      95  => 1975.5332050245,
      96  => 2093.0045224048,
      97  => 2217.4610478150,
      98  => 2349.3181433393,
      99  => 2489.0158697766,
      100 => 2637.0204553030,
      101 => 2793.8258514640,
      102 => 2959.9553816931,
      103 => 3135.9634878540,
      104 => 3322.4375806396,
      105 => 3520.0000000000,
      106 => 3729.3100921447,
      107 => 3951.0664100490,
      108 => 4186.0090448096,
      109 => 4434.9220956300,
      110 => 4698.6362866785,
      111 => 4978.0317395533,
      112 => 5274.0409106059,
      113 => 5587.6517029281,
      114 => 5919.9107633862,
      115 => 6271.9269757080,
      116 => 6644.8751612791,
      117 => 7040.0000000000,
      118 => 7458.6201842894,
      119 => 7902.1328200980,
      120 => 8372.0180896192,
      121 => 8869.8441912599,
      122 => 9397.2725733570,
      123 => 9956.0634791066,
      124 => 10548.0818212118,
      125 => 11175.3034058561,
      126 => 11839.8215267723,
      127 => 12543.8539514160);

private

   function Rep_Size (Msg : Message) return Natural
   is (case Msg.Kind is
          when Note_On | Note_Off | Aftertouch | Continous_Controller => 3,
          when Patch_Change | Channel_Pressure | Pitch_Bend => 2,
          when Sys => (case Msg.Cmd is
                          when Song_Position => 3,
                          when Song_Select | Bus_Select => 2,
                          when Tune_Request | End_Exclusive |
                       Timming_Tick | Start_Song | Continue_Song |
                       Stop_Song | Active_Sensing | Reset => 1,
                          when others => 0));

end MIDI;
