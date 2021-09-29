import 'date-fns';
import { useState } from 'react';
import DateFnsUtils from '@date-io/date-fns';
import {
  MuiPickersUtilsProvider,
  KeyboardDatePicker,
} from '@material-ui/pickers';

export default function MaterialUIPickers({ label, value ,handleDateChange}) {

  return (
    <MuiPickersUtilsProvider utils={DateFnsUtils}>
      <KeyboardDatePicker
        style={{ margin: 0, maxWidth: '18ch' }}
        disableToolbar
        variant="inline"
        format="MM/dd/yyyy"
        label={label}
        value={value}
        onChange={(event,newValue) => handleDateChange(newValue)}
      />
    </MuiPickersUtilsProvider>
  );
}