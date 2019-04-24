package ge.koaladev.msy.nso.core.dao;

import ge.koaladev.msy.nso.database.model.AbstractDAO;
import ge.koaladev.msy.nso.database.model.Championship;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.util.List;

/**
 * Created by NINO on 4/18/2019.
 */
@Repository
public class ChampionshipDAO extends AbstractDAO<Championship> {

    @PersistenceContext(unitName = "nso")
    private EntityManager entityManager;

    @Override
    public EntityManager getEntityManager() {
        return entityManager;
    }

    @Transactional
    public List<Championship> getChampionships(Integer offset, Integer limit, String fullTextSearch) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(Championship.class.getSimpleName()).append(" e Where 1=1 ");
        if (fullTextSearch != null && fullTextSearch.length() > 0) {
            StringBuilder f = new StringBuilder();
            f.append(" and ( ");

            f.append(" e.name like '%" + fullTextSearch + "%'  ");

            f.append(" ) ");

            q.append(f.toString());
        }
        q.append(" order by e.id desc ");
        TypedQuery<Championship> query = entityManager.createQuery(q.toString(), Championship.class);

        if (limit != null && offset != null) {
            query.setFirstResult(offset);
            query.setMaxResults(limit);
        }
        return query.getResultList();
    }

}
