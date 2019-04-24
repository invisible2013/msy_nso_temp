package ge.koaladev.msy.nso.core.dao;

import ge.koaladev.msy.nso.database.model.AbstractDAO;
import ge.koaladev.msy.nso.database.model.CalendarPerson;
import ge.koaladev.msy.nso.database.model.Calendars;
import ge.koaladev.msy.nso.database.model.Result;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.util.List;

/**
 * Created by NINO on 4/2/2018.
 */

@Repository
public class ResultDao extends AbstractDAO<Calendars> {

    @PersistenceContext(unitName = "nso")
    private EntityManager entityManager;

    @Override
    public EntityManager getEntityManager() {
        return entityManager;
    }

    @Transactional
    public List<Result> getResult(Integer userId, String fullTextSearch, Integer limit, Integer offset) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(Result.class.getSimpleName()).append(" e Where 1=1 ");
        if (fullTextSearch != null) {
            StringBuilder f = new StringBuilder();
            f.append(" and ( ");

            f.append("( e.discipline like '%" + fullTextSearch + "%' ) ");

            f.append(" ) ");

            q.append(f.toString());
        }
        q.append(" order by e.id desc ");
        TypedQuery<Result> query = entityManager.createQuery(q.toString(), Result.class);

        if (limit != null && offset != null) {
            query.setFirstResult(offset);
            query.setMaxResults(limit);
        }
        return query.getResultList();
    }



}
