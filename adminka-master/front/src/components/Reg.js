import { TextField } from "@material-ui/core";
import { useState } from "react";

export default function Reg(){
var[firstname, setFirstname] = useState();
var[lastname, setLastname] = useState();
var[patronymic, setPatronymic] = useState(null);
var[gender, setGender] = useState("м");
var[birthday, setBirthday] = useState();
var[login, setLogin] = useState();
var[pwd, setPwd] = useState();
var[telephone, setTelephone] = useState();

const handleClick=(e)=>{
    e.preventDefault()
    fetch("http://localhost:8080/adduser/"+lastname+"/"+firstname+"/"+patronymic+"/"+gender+"/"+birthday+"/"+login+"/"+pwd+"/"+telephone,{
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
        <div className = "loginfield">
            <TextField label="Фамилия" variant="outlined" value = {lastname} onChange={(e)=>setLastname(e.target.value)}/>
            <TextField label="Имя" variant="outlined" value = {firstname} onChange={(e)=>setFirstname(e.target.value)}/>
            <TextField label="Отчество" variant="outlined" value = {patronymic} onChange={(e)=>setPatronymic(e.target.value)}/>
            <p></p>
            <input type="radio" id="contactChoice1" name="contact" value="м" checked />
            <label className = "cc" for="contactChoice1">Муж</label>
            <input type="radio" id="contactChoice2" name="contact" value="ж" onChange={(e)=>setGender(e.target.value)}/>
            <label className = "cc" for="contactChoice2">Жен</label>

            <TextField label="День рождения дд.мм.гггг" variant="outlined" value = {birthday} onChange={(e)=>setBirthday(e.target.value)}/>
            <TextField label="Телефон" variant="outlined" value = {telephone} onChange={(e)=>setTelephone(e.target.value)}/>
            <p></p>
            <TextField label="Логин" variant="outlined" value = {login} onChange={(e)=>setLogin(e.target.value)}/>
            <TextField label="Пароль" variant="outlined" value = {pwd} onChange={(e)=>setPwd(e.target.value)}/>
            <p></p>

            <button onClick={handleClick}>зарегистрироватсья</button>
        </div>
    </form>
    )
}