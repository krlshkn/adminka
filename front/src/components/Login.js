import { useEffect, useState } from "react";
import {Container, TextField}  from '@material-ui/core';


export default function Autoriz(){
    var[user, setUser] = useState([]);
    const[login, setLogin] = useState();
    const[pwd, setPwd] = useState();


    const handleClick=(e)=>{
        e.preventDefault()
        console.log(login);
        fetch("http://localhost:8080/finduser/"+login+"/"+pwd)
        .then(res=>res.json())
        .then((result)=>{
            setUser(result);
            console.log(user);
            sessionStorage.setItem("role", user.role);
        }
        )
        if(user==false){ 
            window.location.replace("/info");
        }
        else{
            alert("Кажется, у вас еще нет аккаунта. Зарегистрируйтесь!");

           // window.location.replace("/programs");
        }
        
        
    }
    
    return(
        <Container>
            <form noValidate autoComplete="off" id="add">
            <TextField label="логин" variant="outlined" value = {login} onChange={(e)=>setLogin(e.target.value)}/>
            <TextField label="пароль" variant="outlined" value = {pwd} onChange={(e)=>setPwd(e.target.value)}/>
            <button onClick={handleClick}>войти</button>
            {user.map(u=>(sessionStorage.setItem("id", u.id),sessionStorage.setItem("role", u.role), sessionStorage.setItem("name", u.name)))}
            <p>{sessionStorage.getItem("role")}</p>
            <p>Не получается зайти? <a href="/reg">Зарегистрируйтесь</a></p>
        </form>
        </Container>
    )
}