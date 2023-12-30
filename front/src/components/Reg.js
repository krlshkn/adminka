import { TextField } from "@material-ui/core";
import { useState } from "react";

export default function Reg(){
var[name, setName] = useState();
var[login, setLogin] = useState();
var[pwd, setPwd] = useState();
var[phoneNumber, setPhonenumber] = useState();

const handleClick=(e)=>{
    e.preventDefault()
    fetch("http://localhost:8080/adduser/"+name+"/"+login+"/"+pwd+"/"+phoneNumber,{
            method:"POST",
            headers:{"Content-Type":"application/json"},
            body:JSON.stringify()
    })
    .then(()=>{
        console.log("user added");
        window.location.replace("/login")
    }
    )
    }    
    return(
        <form noValidate autoComplete="off" id="add">
        <TextField label="Имя" variant="outlined" value = {name} onChange={(e)=>setName(e.target.value)}/>
        <TextField label="Логин" variant="outlined" value = {login} onChange={(e)=>setLogin(e.target.value)}/>
        <TextField label="Пароль" variant="outlined" value = {pwd} onChange={(e)=>setPwd(e.target.value)}/>
        <TextField label="Телефон" variant="outlined" value = {phoneNumber} onChange={(e)=>setPhonenumber(e.target.value)}/>
        <button onClick={handleClick}>зарегистрироватсья</button>
    </form>
    )
}