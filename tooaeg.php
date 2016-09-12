<?php

  // Öise aja algus ja lõpp
  $SETTINGS_nighttime_start = '22:00';
  $SETTINGS_nighttime_end   = '07:00';

  // Töötajad ning nende tööajad
  $EMPLOYEES = array(

    '0' => array(
      'name'        => 'Juhan Jalgratas',
      'shift_start' => '15:15',
      'shift_end'   => '23:45'
    ),

    '1' => array(
      'name'        => 'Mauno Maasikas',
      'shift_start' => '10:00',
      'shift_end'   => '22:00'
    ),

    '2' => array(
      'name'        => 'Kati Kuusemets',
      'shift_start' => '22:30',
      'shift_end'   => '08:00'
    ),

    '3' => array(
      'name'        => 'Pille-Mati Jämispehmut',
      'shift_start' => '20:00',
      'shift_end'   => '10:00'
    ),

    '4' => array(
      'name'        => 'Käsna-Kalle Kantpüks',
      'shift_start' => '09:00',
      'shift_end'   => '17:00'
    ),

    '5' => array(
      'name'        => 'Aita-Leida Kuusepuu',
      'shift_start' => '23:00',
      'shift_end'   => '06:00'
    ),

    '6' => array(
      'name'        => 'Muh Muh',
      'shift_start' => '23:00',
      'shift_end'   => '24:00'
    ),

  );


// Count time by quarters starting at midnight
// Trust input data to respect 15 minute rule from spec? No.
$zero = strtotime("00:00") / 60 / 15;
$morning = round(strtotime($SETTINGS_nighttime_end) / 60 / 15) - $zero;
$evening = round(strtotime($SETTINGS_nighttime_start) / 60 / 15) - $zero;

function set_times(&$its_nighttime, &$its_worktime, $name) {
  if ($name == 'morning') { $its_nighttime = false; }
  if ($name == 'evening') { $its_nighttime = true; }
  if ($name == 'start shift') { $its_worktime = true; }
  if ($name == 'end shift') { $its_worktime = false; }
}

function add_quarters($its_nighttime, $its_worktime, &$shift_quarters, &$night_shift_quarters, $quarters) {
  if ($its_worktime) {
    $shift_quarters += $quarters;
    if ($its_nighttime) {
      $night_shift_quarters += $quarters;
    }
  }
}

$out_a = array();

echo $SETTINGS_nighttime_end."\t=>\t".$SETTINGS_nighttime_start."\n";
echo $morning."\t=>\t".$evening."\n";
foreach( $EMPLOYEES as $key => $employee ) {
  // Round times from input data to closest 15 minutes.
  $shift_start = round(strtotime($employee['shift_start']) / 60 / 15) - $zero;
  $shift_end = round(strtotime($employee['shift_end']) / 60 / 15) - $zero;
  $night_shift = $shift_start > $shift_end;
  $timepoints_array = array(
    array( 'name' => 'morning',     'h_quarters' => $morning ),
    array( 'name' => 'evening',     'h_quarters' => $evening ),
    array( 'name' => 'start shift', 'h_quarters' => $shift_start ),
    array( 'name' => 'end shift',   'h_quarters' => $shift_end )
  );
  usort($timepoints_array, function($a, $b)
  {
    return strcmp($a['h_quarters'], $b['h_quarters']);
  });

  $shift_quarters = 0;
  $night_shift_quarters = 0;
  $its_nighttime = $evening > $morning;
  $its_worktime = $night_shift;

  // Liiga hilja, et tegeleda viie varba ja nelja varbavahe koodi optimeerimisega.
  // 1. Varvas
  add_quarters($its_nighttime, $its_worktime, $shift_quarters, $night_shift_quarters
    , $timepoints_array[0]['h_quarters']);
  // 1. Varbavahe
  set_times($its_nighttime, $its_worktime, $timepoints_array[0]['name']);
  // 2. Varvas
  add_quarters($its_nighttime, $its_worktime, $shift_quarters, $night_shift_quarters
    , $timepoints_array[1]['h_quarters'] - $timepoints_array[0]['h_quarters']);
  // 2. Varbavahe
  set_times($its_nighttime, $its_worktime, $timepoints_array[1]['name']);
  // 3. Varvas
  add_quarters($its_nighttime, $its_worktime, $shift_quarters, $night_shift_quarters
    , $timepoints_array[2]['h_quarters'] - $timepoints_array[1]['h_quarters']);
  // 3. Varbavahe
  set_times($its_nighttime, $its_worktime, $timepoints_array[2]['name']);
  // 4. Varvas
  add_quarters($its_nighttime, $its_worktime, $shift_quarters, $night_shift_quarters
    , $timepoints_array[3]['h_quarters'] - $timepoints_array[2]['h_quarters']);
  // 4. Varbavahe
  set_times($its_nighttime, $its_worktime, $timepoints_array[3]['name']);
  // 5. Varvas
  add_quarters($its_nighttime, $its_worktime, $shift_quarters, $night_shift_quarters
    , 24*4 - $timepoints_array[3]['h_quarters']);

  array_push($out_a, array(
    'name' => $employee['name'],
    'shift_start' => $employee['shift_start'],
    'shift_end' => $employee['shift_end'],
    'shift_length' => $shift_quarters / 4,
    'night_shift_length' => $night_shift_quarters / 4,
    'day_shift_length' => ($shift_quarters - $night_shift_quarters) / 4
  ));
}

print_r($out_a);

?>
