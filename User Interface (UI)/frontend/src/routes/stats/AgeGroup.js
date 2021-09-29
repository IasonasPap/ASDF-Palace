import { useEffect, useState } from 'react';
import { Table } from '../../components';

const columns1 = [
  {
    field: 'title',
    headerName: 'Space',
    width: 200,
  },
  {
    field: 'number of visits',
    headerName: 'Number Of Visits',
    width: 200,
  },
];

const columns2 = [
  {
    field: 'title',
    headerName: 'Service',
    width: 200,
  },
  {
    field: 'number of uses',
    headerName: 'Number Of Uses',
    width: 200,
  },
];


const AgeGroup = ({from , to}) => {
    const [mostVisitedSpaces,setMostVisited] = useState([]);
    const [mostUsedServices,setMostUsed] = useState([]);
    const [servicesUsedFromMostClients,setMostClients] = useState([]);
  
    useEffect(() => {
      fetch(`http://localhost:5000/asdfpalace/stats/mostvisitedspaces/${from}/${to}`)
      .then(response => response.json())
      .then(
        res => {
          let i=1;
          setMostVisited(res.map(row =>{row.id = i++; return row}));}
      );

      fetch(`http://localhost:5000/asdfpalace/stats/mostusedservices/${from}/${to}`)
      .then(response => response.json())
      .then(
        res => {
          let i=1;
          setMostUsed(res.map(row =>{row.id = i++; return row}));}
      );

      fetch(`http://localhost:5000/asdfpalace/stats/usedmostclients/${from}/${to}`)
      .then(response => response.json())
      .then(
        res => {
          let i=1;
          setMostClients(res.map(row =>{row.id = i++; return row}));}
      );
    }, []);
  
    return (
      <div>
        <h1>Most Visited Spaces</h1>
        <Table
          rows={mostVisitedSpaces}
          columns={columns1}
        />
        <h1>Most Used Services</h1>
        <Table
          rows={mostUsedServices}
          columns={columns2}
        />
        <h1>Services Used From Most Clients</h1>
        <Table
          rows={servicesUsedFromMostClients}
          columns={columns2}
        />
      </div>
    );
  };
  
export default AgeGroup;
  