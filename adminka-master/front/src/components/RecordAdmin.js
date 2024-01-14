import { Container, DateField, TextField } from "@material-ui/core";
import { useEffect, useState } from "react";

export default function RecordAdmin(){
    const [futurerecords, setFutureRecords]=useState([]);
    const [freerecords, setFreeRecords]=useState([]);
    const[programid, setProgramId] = useState();
    const[programName, setProgram] = useState();
    const[users, setUsers] = useState([]);

    const[datep, setDate]=useState();
    const[timep, setTime]=useState();
    const[programs, setPrograms] = useState([]);

    useEffect(()=>{
                fetch("http://localhost:8080/futurerecords")
                .then(res=>res.json())
                .then((result)=>{
                    setFutureRecords(result);
                }
                )
                fetch("http://localhost:8080/freerecords")
                .then(res=>res.json())
                .then((result)=>{
                    setFreeRecords(result);
                }
                )
                fetch("http://localhost:8080/getprograms")
                .then(res=>res.json())
                .then((result)=>{
                    setPrograms(result);
                }
                )
                fetch("http://localhost:8080/getusers")
                .then(res=>res.json())
                .then((result)=>{
                    setUsers(result);
                }
                )
                
            }, [])


                
            const handleClick=(e)=>{
                e.preventDefault()
                fetch("http://localhost:8080/getprogrambyname/"+programName)
                .then(res=>res.json())
                .then((result)=>{
                    setProgramId(result);
                }
                )
                var date = new Date(datep);
                console.log(date);
                var time = new Number(timep);
                var members=new Number(2);
                var customer=new Number(1);
                var status=new Number(1);
                var program = new Number(programid)
                const record ={program, date, time, members, customer, status}
                
                    fetch("http://localhost:8080/addrecord",{
                        method:"POST",
                        headers:{"Content-Type":"application/json"},
                        body:JSON.stringify(record)
                })
                .then(()=>{
                    console.log("record added");
                    window.location.reload();

                }
                )
                }    

                function deleteClick(id){
                var record = new Number(id);
                var status = new Number(2);
                
                fetch("http://localhost:8080/updaterecord/"+record+"/"+status,{
                    method:"PUT",
                    headers:{"Content-Type":"application/json"},
                    body:JSON.stringify(record) 
                })
                .then(()=>{
                    console.log("record put added");
                    window.location.reload();
                }
                )
                }    
                
        
    return(
        <Container>
            <div className="aadmin">
            <a href="#add">добавить</a><a href="#free">свободные</a> <a href="#future">предстоящие</a>
            </div>
            
          <h5 id="future">  Предстоящие записи</h5>
        {futurerecords.map(record=>(
            <div className="record_card_one" key = {record.id}>      
                   {programs.map(program =>(sessionStorage.setItem(`prog${program.id}`, program.name)))}     
                   {users.map(user =>(sessionStorage.setItem(`user${user.id}`, user.login)))}    
            <p className="recordp">{record.date}&nbsp;&nbsp;&nbsp;{record.time}:00 &nbsp;&nbsp;&nbsp; {sessionStorage.getItem(`prog${record.program}`)}&nbsp;&nbsp;&nbsp; {sessionStorage.getItem(`user${record.customer}`)}</p>
            {/* <button onClick={()=>deleteClick(record.id)}> Удалить</button> */}
            
           
 </div>
        ))}
       <h5 id="free"> Прошедшие записи</h5>
        {freerecords.map(record=>(
            <div className="record_card_one"  key = {record.id}>
                    {programs.map(program =>(sessionStorage.setItem(`${program.id}`, program.name)))}
            <p className="recordp">{record.date}&nbsp;&nbsp;&nbsp;{record.time}:00 &nbsp;&nbsp;&nbsp;{sessionStorage.getItem(record.program)}&nbsp;&nbsp;&nbsp; {sessionStorage.getItem(record.customer)}</p>
            {users.map(user =>(sessionStorage.setItem(`${user.id}`, user.login)))}
            <button onClick={()=>deleteClick(record.id)}> Удалить</button>
           
 </div>
        ))}
    
        <form noValidate autoComplete="off" id="add">
            <TextField label="Программа" variant="outlined" value = {programName} onChange={(e)=>setProgram(e.target.value)}/>
            <TextField label="Дата (мм.чч.гггг)" variant="outlined" value = {datep} onChange={(e)=>setDate(e.target.value)}/>
            <TextField label="Время (укажите час)" variant="outlined" value = {timep} onChange={(e)=>setTime(e.target.value)}/>
            <button onClick={handleClick}>добавить запись</button>
        </form>
    </Container>

    )
}