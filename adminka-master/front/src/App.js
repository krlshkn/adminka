import './App.css';
import { Routes, Route } from 'react-router-dom/dist';
import Header from './components/Header';
import Order from './components/Order';
import Record from './components/Record';
import Programs from './components/Programs';
import RecordAdmin from './components/RecordAdmin';
import Login from './components/Login.js';
import Acc from './components/Acc';
import Admin from './components/Admin';
import ProductAdmin from './components/ProductAdmin';
import Info from './components/Info';
import Reg from './components/Reg';
import Products from './components/Products.js';

function App() {
  return (
    <>
    <Header />
    <Routes>
        <Route path="/info" element={<Info />} />
        <Route path="/products" element={<Products />} />
        <Route path="/order" element={<Order />} />
        <Route path="/record" element={<Record />} />
        <Route path="/recordadmin" element={<RecordAdmin />} />
        <Route path="/login" element={<Login />} />
        <Route path="/reg" element={<Reg />} />
        <Route path="/programs" element={<Programs />} />
        <Route path="/account" element={<Acc />} />
        <Route path="/admin" element={<Admin />} />
        <Route path="/productadmin" element={<ProductAdmin />} />

        <Route path="*" element={<h1>Страница не найдена</h1>} />
    </Routes> 
</>
  );
}

export default App;
