import { useEffect, useState } from "react";
import {Container, TextField}  from '@material-ui/core';


export default function Autoriz(){
    var[account, setAccount] = useState([]);
    const[login, setLogin] = useState();
    const[pwd, setPwd] = useState();


    const handleClick=(e)=>{
        e.preventDefault()
        fetch("http://localhost:8080/finduser/"+login+"/"+pwd)
        .then(res=>res.json())
        .then((result)=>{
            setAccount(result);
            if(account[0] != undefined){
            sessionStorage.setItem("role", account[0].role);
            sessionStorage.setItem("name", account[0].firstName);
            }
            console.log(sessionStorage);
        }
        )
        if(account==false){ 
            // window.location.replace("/programs");
        }
        
        
        
    }
    
    return(
        <Container>
            <form noValidate autoComplete="off" id="add">
            <div className = "loginfield">
                <TextField  label="логин" variant="outlined" value = {login} onChange={(e)=>setLogin(e.target.value)}/>
                <TextField label="пароль" variant="outlined" value = {pwd} onChange={(e)=>setPwd(e.target.value)}/>
                <button onClick={handleClick}>войти</button>
                {account.map(u=>(sessionStorage.setItem("id", u.id),sessionStorage.setItem("role", u.role), sessionStorage.setItem("name", u.firstName)))}
                <p>{sessionStorage.getItem("role")}</p>
                <p>Не получается зайти? <a href="/reg">Зарегистрируйтесь</a></p>
            </div>
        </form>
        </Container>
    )
}