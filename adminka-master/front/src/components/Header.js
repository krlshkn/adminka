export default function Header() {
    var programs;
    var products;
    var login;
    if(sessionStorage.getItem("role")== "заказчик") {
        programs = "/programs";
        products = "/products";
        login= "/account";
    }
    else if(sessionStorage.getItem("role")== "админ") {
        programs= "/recordadmin";
        products = "/productadmin"
        login="/admin";
    }
    else{
        programs= "/programs";
        products = "/products";
        login= "/login";
    } 
    console.log(sessionStorage)
    return (
        <header>
                <div className="header" >
                    <div className="left_part">
                    <a href="/info" className="link">о нас</a>
                    <a href={programs} className="ink">программы</a>
                    <a href={products} className="link">заказать</a>
                    </div>
                    <div className="right_part">
                    <a href={login} className="ink">😊 {sessionStorage.getItem("name")}</a>
                    </div>
                </div>
        </header>
    );
}
