import { Container, DateField, TextField  } from "@material-ui/core";
import { useEffect, useState } from "react";

export default function Record(){
    const[members, setMembers] = useState();
    const[datep, setDate]=useState();
    const[timep, setTime]=useState();
    console.log(sessionStorage.getItem("role"));
    if(sessionStorage.getItem("role")==null || sessionStorage.getItem("role")=="гость"){
        alert("Вы не авторизовались, нажмите на смайлик");
        window.location.replace("/programs")
    }
   
    const id = sessionStorage.getItem("programid");

    var customerid= sessionStorage.getItem("id");
    var pic = sessionStorage.getItem("programpic");

            const handleClick=(e)=>{
                e.preventDefault()

                var date = String(datep);
                var time = Number(timep);
                var members=Number(2);
                var customer=Number(customerid);
                var program = Number(id)
                console.log(date);
                    fetch("http://localhost:8080/addrecord/"+program+"/"+date+"/"+time+"/"+customer+"/"+members,{
                        method:"POST",
                        headers:{"Content-Type":"application/json"},
                        body:JSON.stringify()
                })
                .then(()=>{
                    console.log("record added");
                    // window.location.reload();

                }
                )
                }  
            
            
            // const addRecord=(recordid)=>{
            //     //if(sessionStorage.getItem("role"!="guest")){
            //     var record = new Number(recordid);
            //     var status = new Number(0);

            //     fetch("http://localhost:8080/updaterecord/"+record+"/"+customerid+"/"+status,{
            //         method:"PUT",
            //         headers:{"Content-Type":"application/json"},
            //         body:JSON.stringify(record) 
            //     })
            //     .then(()=>{
            //         console.log("record put added");
            //         window.location.reload();
            //         //alert("Вы записаны! Можете посмотреть данные записи в личном кабинете");
            //     }
            //     )
            //     //else alert("Вы не зарегистрированы! Нажмите на смайлик и авторизуйтесь")
            //     }    
            //     const button = document.querySelector("#myButton");
            //     button.onClick = function (evt) {
            //         evt.preventDefault();
            //     }
                
    return(
        <Container>
                    <div className="product_card_one">
            <img src= {pic}></img>
            <div className="product_title">
                максимум участников - {sessionStorage.getItem("programmax")} <br></br>
            </div>
            
        </div>
        <div className="desc">
        <p>{sessionStorage.getItem("programdescription")}</p>
        </div>
            <form noValidate autoComplete="off" id="add">
            <TextField label="Дата (мм.чч.гггг)" variant="outlined" value = {datep} onChange={(e)=>setDate(e.target.value)}/>
            <TextField label="Время (укажите час)" variant="outlined" value = {timep} onChange={(e)=>setTime(e.target.value)}/>
            <TextField label="Кол-во участников" variant="outlined" value = {members} onChange={(e)=>setMembers(e.target.value)}/>
            <button onClick={handleClick}>добавить запись</button>
        </form>
            {/* <h1>{sessionStorage.getItem("programname")}</h1>
        <div className="product_card_one">
            <img src= {pic}></img>
            <div className="product_title">
                максимум участников - {sessionStorage.getItem("programmax")} <br></br>
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
                <option id="min" selected value="1">1</option>
                <option id="max" value={sessionStorage.getItem("programmax")}>{sessionStorage.getItem("programmax")}</option>
            </select>
 
            &nbsp;&nbsp;&nbsp; 
            цена: {sessionStorage.getItem("programprice")} руб &nbsp;&nbsp;&nbsp; 
            <button id="myButton" onClick={ ()=>addRecord(record.id)}>Записаться</button>
                </div>

        ))}
    </div> */}
    </Container>

    )
 }