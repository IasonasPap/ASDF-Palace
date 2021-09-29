const express = require('express');
const pool = require("./config/db.connect")

const router = express.Router();


router.get("/services", (req, res, next) => {
    pool.connect().then((db) => {
            var queryString = 'select * from Services';
        
            db.request().query(queryString, (err, result) => {
                if(err)
                    console.log(err)
                else 
                    res.send(result.recordset)
            })
        })
});

router.get("/clients", (req, res, next) => {
    pool.connect().then((db) => {
        
            var queryString = 'select * from clients_info';
        
            db.request().query(queryString, (err, result) => {
                if(err)
                    console.log(err)
                else 
                    res.send(result.recordset)
            })
        })
});

router.get("/sales", (req, res, next) => {
    pool.connect().then((db) => {
        
            var queryString = 'select * from sales_per_service';
        
            db.request().query(queryString, (err, result) => {
                if(err)
                console.log(err)
                else 
                    res.send(result.recordset)
            })
        })
});

router.get("/covid/:nfc_id", (req, res, next) => {
    const nfc_id = req.params.nfc_id;

    pool.connect().then((db) => {
        
            var queryString = 
            `select title, location, entry_time, exit_time
            from Spaces, Visits
            where nfc_id=${nfc_id} and id=space_id
            `;
        
            db.request().query(queryString, (err, result) => {
                if(err)
                console.log(err)
                else 
                    res.send(result.recordset)
            })
        })
});

router.get("/infected/:nfc_id", (req, res, next) => {
    const nfc_id = req.params.nfc_id;

    pool.connect().then((db) => {
        
            var queryString = 
            `select v.nfc_id, v.entry_time, v.exit_time, title
            from Spaces as s, Visits as v, (select * from visits where nfc_id=${nfc_id}) as covidVisits
            where v.nfc_id<>${nfc_id} and covidVisits.space_id = v.space_id and v.space_id=id and (
            (title like 'Corridor%' and 
            (DATEDIFF(minute, covidVisits.exit_time, v.entry_time) between 0 and 60 or
            DATEDIFF(minute, covidVisits.entry_time, v.entry_time) between 0 and 60 or
            DATEDIFF(minute, covidVisits.exit_time, v.exit_time) between 0 and 60 or
            DATEDIFF(minute, covidVisits.entry_time, v.exit_time) between 0 and 60)
            ) or
                (Title not like 'Corridor%' and
            (v.entry_time between covidVisits.entry_time and covidVisits.exit_time) or 
            (v.exit_time between covidVisits.entry_time and covidVisits.exit_time) or 
            (DATEDIFF(minute, covidVisits.exit_time, v.entry_time) between 0 and 60)
            ))
            `;
        
            db.request().query(queryString, (err, result) => {
                if(err)
                console.log(err)
                else 
                    res.send(result.recordset)
            })
        })
});

router.get("/stats/mostvisitedspaces/:from/:to", (req, res, next) => {
    const {from,to}= req.params;

    pool.connect().then((db) => {
        
            var queryString = 
            `
            select title,count(space_id) as 'number of visits'
            from Clients as c, Visits as v, Spaces
            where c.nfc_id=v.nfc_id and (FLOOR(DATEDIFF(DAY, birthday, GETDATE()) / 365.25) between ${from} and ${to}) and space_id=id
            group by title
            order by count(space_id) desc
            `;
        
            db.request().query(queryString, (err, result) => {
                if(err)
                console.log(err)
                else 
                    res.send(result.recordset)
            })
        })
});

router.get("/stats/mostusedservices/:from/:to", (req, res, next) => {
    const {from,to}= req.params;

    pool.connect().then((db) => {
        
            var queryString = 
            `
            select title,count(service_id) as 'number of uses'
            from Clients as c, UseService as u, Services
            where c.nfc_id=u.nfc_id and (FLOOR(DATEDIFF(DAY, birthday, GETDATE()) / 365.25) between ${from} and ${to}) and service_id=id
            group by title
            order by count(service_id) desc
            `;
        
            db.request().query(queryString, (err, result) => {
                if(err)
                console.log(err)
                else 
                    res.send(result.recordset)
            })
        })
});

router.get("/stats/usedmostclients/:from/:to", (req, res, next) => {
    const {from,to}= req.params;

    pool.connect().then((db) => {
        
            var queryString = 
            `
            select title,count(distinct u.nfc_id) as 'number of uses'
            from Clients as c, UseService as u, Services
            where c.nfc_id=u.nfc_id and (FLOOR(DATEDIFF(DAY, birthday, GETDATE()) / 365.25) between ${from} and ${to}) and service_id=id
            group by title
            order by count(distinct u.nfc_id) desc
            `;
        
            db.request().query(queryString, (err, result) => {
                if(err)
                console.log(err)
                else 
                    res.send(result.recordset)
            })
        })
});

router.post("/visits", (req, res, next) => {
    const {service, costFrom, costTo, dateFrom, dateTo} = req.body;
    
    let queryString ;

    if (!costFrom && !service)
        queryString = `
        select nfc_id, title, entry_time, exit_time
        from Visits,Spaces
        where space_id=id
        `
    else if (!costFrom) {
        queryString = `
        select nfc_id, sp.title, entry_time, exit_time
        from Visits as v, ServiceInSpace as sis, Services as se ,Spaces as sp
        where se.title='${service}' and se.id=service_id and sis.space_id=v.space_id and v.space_id=sp.id
        `
            
    } else if (!service) {
        queryString = `
        select v.nfc_id, title, entry_time, exit_time
        from Visits as v, ServiceInSpace as s, UseService as u,Spaces as sp, Payments as p
        where (cost between ${costFrom} and ${costTo}) and v.nfc_id=u.nfc_id and u.service_id=s.service_id and s.space_id=v.space_id and v.space_id=sp.id and payment_id=p.id
        `
    } else {
        queryString = `
        select v.nfc_id, sp.title, entry_time, exit_time
        from Visits as v, ServiceInSpace as s, UseService as u,Spaces as sp, Services as ser, Payments as p
        where (cost between ${costFrom} and ${costTo}) and v.nfc_id=u.nfc_id and u.service_id=s.service_id and s.space_id=v.space_id and v.space_id=sp.id and ser.title='${service}' and ser.id=s.service_id and payment_id=p.id
        `
    }

    if(dateFrom) {
        queryString += ` and (CONVERT(varchar(10), entry_time, 101) between '${dateFrom}' and '${dateTo}' or CONVERT(varchar(10), exit_time, 101) between '${dateFrom}' and '${dateTo}')`
    }
    console.log(queryString);
    pool.connect().then((db) => {
        
            db.request().query(queryString, (err, result) => {
                if(err)
                console.log(err)
                else 
                    res.send(result.recordset)
            })
        })
});


module.exports = router;