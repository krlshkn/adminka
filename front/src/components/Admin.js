import { Container, DateField, TextField } from "@material-ui/core";
import { useEffect, useState } from "react";
export default function Admin(){
    // if(sessionStorage.getItem("role")=="user" || sessionStorage.getItem("role")=="guest") window.location.replace("*");

    var [users, setUsers]=useState([]);
    var[status, setStatus] = useState();

    useEffect(()=>{
                fetch("http://localhost:8080/getusers")
                .then(res=>res.json())
                .then((result)=>{
                    setUsers(result);
                }
                )
            }, [])
  
                
                const updateOrder=(orderid)=>{
                    var user = new Number(orderid);                    
                    fetch("http://localhost:8080/updateuser/"+user+"/"+status,{
                        method:"PUT",
                        headers:{"Content-Type":"application/json"},
                        body:JSON.stringify(user) 
                    })
                    .then(()=>{
                        console.log("record put added");
                        window.location.reload();
                    }
                    )
                    } 

                const enter=(e)=>{
                        e.preventDefault()
                        sessionStorage.clear();
                        window.location.replace("/login");
                    }
    return(
        <Container>
            <button onClick={enter}>выход</button>
           <h1> список пользователей</h1>
        {users.map(user=>(
            <div className="order_card_one" key = {user.id}>    
            <p className="adm">{user.id}</p>
            <p className="adm">{user.name}</p>
             <p className="adm">{user.login}</p>
             <p className="adm">{user.pwd}</p>
            <p className="adm">{user.role}</p>
            <p className="adm">{user.phonenumber}</p>
                <TextField id = {user.id} label={user.status} variant="outlined"  onChange={(e)=>setStatus(e.target.value)}/>
            <button onClick={()=>(updateOrder(user.id))}>обновить</button>
            
                  
 </div>
        ))}
       
    </Container>

    )


}