package com.mypottery.pottery.repo;

import com.mypottery.pottery.model.Account;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AccountRepository extends JpaRepository<Account, Integer> {
}