/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dao;

import ge.koaladev.msy.nso.database.model.AbstractDAO;
import ge.koaladev.msy.nso.database.model.Event;
import ge.koaladev.msy.nso.database.model.UserBudget;
import ge.koaladev.msy.nso.database.model.Users;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TemporalType;
import javax.persistence.TypedQuery;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author mindia
 */
@Repository
public class UserDao extends AbstractDAO<User> {

    @PersistenceContext(unitName = "nso")
    private EntityManager entityManager;

    @Override
    public EntityManager getEntityManager() {
        return entityManager;
    }

    @Transactional
    public List<Users> getUsersByGroup(int groupId) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(Users.class.getSimpleName()).append(" e Where e.usersGroup.id =").append(groupId);
        TypedQuery<Users> query = entityManager.createQuery(q.toString(), Users.class);
        return query.getResultList();
    }

    @Transactional
    public List<Users> getUsersBySupervisor(int supervisorId) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(Users.class.getSimpleName()).append(" e Where e.supervisorId =").append(supervisorId);
        TypedQuery<Users> query = entityManager.createQuery(q.toString(), Users.class);
        return query.getResultList();
    }

    @Transactional
    public List<Users> getUsersByManager(int managerId) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(Users.class.getSimpleName()).append(" e Where e.managerId =").append(managerId);
        TypedQuery<Users> query = entityManager.createQuery(q.toString(), Users.class);
        return query.getResultList();
    }

    @Transactional
    public List<Users> getUsersById(List<Integer> ids) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(Users.class.getSimpleName()).append(" e Where e.id in(:ids)");
        TypedQuery<Users> query = entityManager.createQuery(q.toString(), Users.class);
        query.setParameter("ids", ids);
        return query.getResultList();
    }

    @Transactional
    public List<UserBudget> getUserBudget(int userId) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(UserBudget.class.getSimpleName()).append(" e Where e.userId =").append(userId);
        TypedQuery<UserBudget> query = entityManager.createQuery(q.toString(), UserBudget.class);
        return query.getResultList();
    }

    @Transactional
    public List<Event> getUserBudgetByYear(int userId, Date startDate, Date endDate) {
        StringBuilder q = new StringBuilder();
        Map<String, Object> params = new HashMap<>();

        q.append("Select e From ").append(Event.class.getSimpleName()).append(" e Where e.senderUser.id =").append(userId);
        q.append(" and e.eventDecision.id = 1");
        if (startDate != null) {
            q.append(" and e.createDate >=:startDate ");
            params.put("startDate", startDate);
        }
        if (endDate != null) {
            q.append(" and e.createDate <= :endDate");
            params.put("endDate", endDate);
        }
        TypedQuery<Event> query = entityManager.createQuery(q.toString(), Event.class);

        for (Map.Entry<String, Object> entry : params.entrySet()) {
            if (entry.getValue() instanceof Date) {
                query.setParameter(entry.getKey(), (Date) entry.getValue(), TemporalType.TIMESTAMP);
            } else {
                query.setParameter(entry.getKey(), entry.getValue());
            }
        }

        return query.getResultList();
    }

}
