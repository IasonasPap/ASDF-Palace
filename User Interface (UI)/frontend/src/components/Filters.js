import { Button, Grid, TextField } from "@material-ui/core";
import { Autocomplete } from "@material-ui/lab";
import DatePicker from "./DatePicker";
import { useStyles } from "./styles";
import { useEffect, useState } from 'react';

const Filters = ({ handleSearchVisits}) => {
  const classes = useStyles();
  const [services, setServices] = useState([]);

  const [service, setService] = useState(null);
  const [costFrom, setCostFrom] = useState("");
  const [costTo, setCostTo] = useState("");
  const [dateFrom, setDateFrom] = useState(null);
  const [dateTo, setDateTo] = useState(null);

  useEffect(() => {
    fetch("http://localhost:5000/asdfpalace/services")
      .then(response => response.json())
      .then( res => setServices(res.map(({title}) => title) ));
  }, []);

  const handleDateFromChange = date => setDateFrom(date)
  const handleDateToChange = date => setDateTo(date)

  const handleSearch = () => {    
    console.log(service,costFrom,costTo,dateFrom,dateTo)

    if(!service && !costFrom && !costTo && !dateFrom && !dateTo) {alert('No Filters Provided'); return;}
    if((costFrom && !costTo) || (!costFrom && costTo)) {alert('Provide Both Costs'); return;}
    if((dateFrom && !dateTo) || (!dateFrom && dateTo)) {alert('Provide Both Dates'); return;}

    const filters = {
      service,
      costFrom,
      costTo,
      dateFrom,
      dateTo
    }
    console.log(filters);
    console.log(JSON.stringify(filters));

    fetch("http://localhost:5000/asdfpalace/visits",{
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(filters)})
      .then(response => response.json())
      .then( res => {
        let i=1;
        handleSearchVisits(res.map(row =>{
          row.id = i++;           
          row.entry_time = row.entry_time.replace('T', ' ').replace('Z', '');
          row.exit_time = row.exit_time.replace('T', ' ').replace('Z', '');
          return row
        }))
      });
  }

  return (
    <Grid
      container
      style={{ gap: '24px', marginBottom: '24px' }}
      alignItems="flex-end"
    >
      <Autocomplete
        size="small"
        options={services}
        value={service}
        onChange={(event, newValue) => setService(newValue) }
        style={{ maxWidth: '30ch', width: '100%' }}
        renderInput={(params) => <TextField {...params} label="Service" variant="outlined" />}
      />

      <div className={classes.flex}>
        <TextField
          style={{ maxWidth: '16ch' }}
          type="number"
          label="Cost-from"
          size="small"
          variant="outlined"
          value={costFrom}
          onChange={(event) => setCostFrom(event.target.value)}
        />

        <TextField
          style={{ maxWidth: '16ch' }}
          type="number"
          label="Cost-to"
          size="small"
          variant="outlined"
          value={costTo}
          onChange={(event) => setCostTo(event.target.value)}
        />
      </div>

      <div className={classes.flex}>
        <DatePicker label={'from'} value={dateFrom} handleDateChange={handleDateFromChange} />
        <DatePicker label={'to'} value={dateTo} handleDateChange={handleDateToChange} />
      </div>

      <Button
        color="primary"
        variant="contained"
        size="small"
        onClick={() => handleSearch()
        }
      >
        Search
      </Button>

      <Button
        color="primary"
        variant="contained"
        size="small"
        onClick={() => {
          setService(null);
          setCostFrom("");
          setCostTo("");
          setDateFrom(null);
          setDateTo(null);
        }}
      >
        Clear
      </Button>
    </Grid>
  );
};



export default Filters;
