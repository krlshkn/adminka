import { Container, DateField } from "@material-ui/core";
import { useEffect, useState } from "react";

export default function Record(){
    const [records, setRecords]=useState([]);
   
    const id = sessionStorage.getItem("programid");

    var customerid= sessionStorage.getItem("id");
    useEffect(()=>{
                fetch("http://localhost:8080/record/"+id)
                .then(res=>res.json())
                .then((result)=>{
                    setRecords(result);
                }
                )
            }, [])

            var pic = sessionStorage.getItem("programpic");
            
            const addRecord=(recordid)=>{
                //if(sessionStorage.getItem("role"!="guest")){
                var record = new Number(recordid);
                var status = new Number(0);

                fetch("http://localhost:8080/updaterecord/"+record+"/"+customerid+"/"+status,{
                    method:"PUT",
                    headers:{"Content-Type":"application/json"},
                    body:JSON.stringify(record) 
                })
                .then(()=>{
                    console.log("record put added");
                    window.location.reload();
                    //alert("Вы записаны! Можете посмотреть данные записи в личном кабинете");
                }
                )
                //else alert("Вы не зарегистрированы! Нажмите на смайлик и авторизуйтесь")
                }    
                // const button = document.querySelector("#myButton");
                // button.onClick = function (evt) {
                //     evt.preventDefault();
                // }
                
    return(
        <Container>
            <h1>{sessionStorage.getItem("programname")}</h1>
        <div className="product_card_one">
            <img src= {pic}></img>
            <div className="product_title">
                {sessionStorage.getItem("programmin")}-{sessionStorage.getItem("programmax")} человек<br></br>
                {sessionStorage.getItem("programhours")} часа<br></br>
                по расписанию
            </div>
            
        </div>
        <div className="desc">
        <p>{sessionStorage.getItem("programdescription")}</p>
        </div>
        <div>
        {records.map(record=>(
                <div className="record_card" key={record.id}>
                    
            {record.date}&nbsp;&nbsp;&nbsp;{record.time}:00 &nbsp;&nbsp;&nbsp;
            количество человек <select name="select" size="1" multiple>
                <option id="min" selected value={sessionStorage.getItem("programmin")}>{sessionStorage.getItem("programmin")}</option>
                <option id="max" value={sessionStorage.getItem("programmax")}>{sessionStorage.getItem("programmax")}</option>
            </select>
 
            &nbsp;&nbsp;&nbsp; 
            цена: {sessionStorage.getItem("programprice")} руб &nbsp;&nbsp;&nbsp; 
            <button id="myButton" onClick={ ()=>addRecord(record.id)}>Записаться</button>
            {/* <input type="button" value="Записаться" onClick={addRecord(record.date, record.time, sessionStorage.getItem("programmin"))}></input> */}
                </div>

        ))}
    </div>
    </Container>

    )

 }