package com.mypottery.pottery.repo;

import com.mypottery.pottery.model.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CustomerRepo extends JpaRepository<Customer, Integer> {
    List<Customer> findByRole(String role);
    List<Customer> findByLogin(String login);
    Customer findUserById(int id);

}
