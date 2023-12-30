// import { Container, TextField } from "@material-ui/core";
// import { useEffect, useState } from "react";
import $ from 'jquery';
import { useEffect, useState } from 'react';

 export default function Timetable(){
    const[records, setRecords]=useState([]);
    useEffect(()=>{
        fetch("http://localhost:8080/records")
        .then(res=>res.json())
        .then((result)=>{
            setRecords(result);
        }
        )
    }, [])
    $( function() {
        $( "ol" ).selectable();
      } );
    return(
        <div>
        {records.map(record=>(
        <ol id="selectable">
            <p className="ui-state-default">{record.date} {record.time}</p>
            <li class="ui-state-default"></li>
            <li class="ui-state-default">2</li>
            <li class="ui-state-default">3</li>
            <li class="ui-state-default">4</li>
            <li class="ui-state-default">5</li>
            <li class="ui-state-default">6</li>
            <li class="ui-state-default">7</li>
            <li class="ui-state-default">8</li>
            <li class="ui-state-default">9</li>
            <li class="ui-state-default">10</li>
            <li class="ui-state-default">11</li>
            <li class="ui-state-default">12</li>
</ol>
 ))}
 </div>
    )
 }
//     const[records, setRecords]=useState([]);
//       useEffect(()=>{
//         fetch("http://localhost:8080/records")
//         .then(res=>res.json())
//         .then((result)=>{
//             setRecords(result);
//         }
//         )
//     }, [])
//     return(
//         <Container>
//         <div>
//             <
//             <Drop label = "id"></TextField>
//             <h1>записи</h1>
//             <div>
//                 {records.map(record=>(
//                         <div className="record_card" key={record.id}>
// {record.date}                        {record.time}:00 кол-во человек{record.members} цена:{record.price}руб
//                         </div>
//                                             // <input className="input_class" type="checkbox" name={record.name} id={record.id} pattern={record.width} src={record.picture} placeholder={record.type} readOnly={record.price}></input>

//                 ))}
//             </div>
//            {/* <a href="/order"><button id="order_button" onClick={orderButton}>оформить заказ</button></a> */}
//            {/* <button id="order_button" onClick={orderButton}>оформить заказ</button> */}
            
//         </div>    
//         </Container>
//     )
// }
// //     const [arrTable, setArrTable]=useState([]);
// //     useEffect(()=>{
// //         const day = ["пн", "вт", "ср", "чт", "пт", "сб", "вс"];

// //         const date = new Date(new Date().getTime()+24*60*60*1000);
// //         let newDate;
// //         const year = date.getFullYear();
// //         const month = date.getMonth();
// //         const dateforWeak = date.getDate();
// //         const d=date.getDate();

// //         for(let i=0; i<7; i++){
// //             newDate = new Date(year, month, d+1);
// //             tWeek.push({text:day[(dateforWeak+i)%7]+" "+newDate.getDate(), db:newDate});

// //         }
// //         setWeek(tWeek)
// //         createTable(-1, tWeek);
// //     }, [])
// // }

// // function createTable(nowHall, week){
// //     const _arrTable = [];
// //     week.forEach(t => {
// //         _arrTable.push({time: Number(t.substring(0,2)), date: w.db, hall: nowHall, state:0})
// //     })
// //     setArrTable(_arrTable);
// //     return _arrTable;
// // }
// // function fillTable(_arrTable){
// //     let arr = _arrTable.map((item) => {
// //         let bDate = bookDB.filter(b => b.year == item.date.getFullYear() && b.month == item.date.getMonth() && b.day==item.date.getDate());
// //         let bTime=[];
// //         if(bDate.length!=0){bTime = bDate.filter(b=> b.time === item.time);}
// //         let bHall = [];

// //         if(bTime.length!=0){bHall = bTime.filter(b=> d.idHall === item.hall)}
// //         if(bHall.length!=0) item.state=1;
// //         return item;
// //     })
// // }