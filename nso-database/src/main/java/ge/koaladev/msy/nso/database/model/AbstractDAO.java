package ge.koaladev.msy.nso.database.model;


import ge.koaladev.msy.nso.database.misc.ParamValuePair;

import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;

/**
 * @author mindia
 */
public abstract class AbstractDAO<T> {

    public abstract EntityManager getEntityManager();

    public <T> T create(T object) {
        getEntityManager().persist(object);
        return object;
    }

    public <T> T update(T object) {
        return getEntityManager().merge(object);
    }

    public <T> void delete(T object) {
        getEntityManager().remove(object);
    }

    public <T> T find(Class object, Object identifier) {
        return (T) getEntityManager().find(object, identifier);
    }

    public <T> List<T> getAll(Class<T> clazz) {
        TypedQuery<T> query = getEntityManager().createQuery("Select a from " + clazz.getSimpleName() + " a", clazz);
        return query.getResultList();
    }

    public <T> List<T> getAllByParamValue(Class<T> clazz, List<ParamValuePair> paramValues) {

        StringBuilder q = new StringBuilder();
        q.append("Select tbl From ").append(clazz.getSimpleName()).append("  tbl Where 1 = 1 ");

        for (ParamValuePair pair : paramValues) {
            q.append(" and  tbl.").append(pair.getParamName()).append("  = :").append(pair.getParamName());
        }
        TypedQuery<T> query
                = getEntityManager().createQuery(q.toString(), clazz);

        for (ParamValuePair pair : paramValues) {
            query.setParameter(pair.getParamName(), pair.getParamValue());
        }

        return query.getResultList();
    }

    public <T> List<T> getAllByParamValueByLimits(Class<T> clazz, List<ParamValuePair> paramValues, Integer offset, Integer limit,String fullTextSearch) {

        StringBuilder q = new StringBuilder();
        q.append("Select tbl From ").append(clazz.getSimpleName()).append("  tbl Where 1 = 1 ");

        for (ParamValuePair pair : paramValues) {
            q.append(" and  tbl.").append(pair.getParamName()).append("  = :").append(pair.getParamName());
        }

        if (fullTextSearch != null) {
            StringBuilder f = new StringBuilder();
            f.append(" and ( ");

            f.append("( tbl.firstName like '%" + fullTextSearch + "%' ) ");
            f.append("or ( tbl.personalNumber like '%" + fullTextSearch + "%' ) ");
            f.append("or ( tbl.lastName like '%" + fullTextSearch + "%' ) ");
            f.append("or ( tbl.position like '%" + fullTextSearch + "%' ) ");
            f.append("or ( tbl.weightCategory like '%" + fullTextSearch + "%' ) ");
            f.append("or ( tbl.club like '%" + fullTextSearch + "%' ) ");
            f.append("or ( tbl.city like '%" + fullTextSearch + "%' ) ");
            f.append("or ( tbl.trainer like '%" + fullTextSearch + "%' ) ");
            f.append("or ( tbl.category like '%" + fullTextSearch + "%' ) ");

            f.append(" ) ");

            q.append(f.toString());
        }

        TypedQuery<T> query
                = getEntityManager().createQuery(q.toString(), clazz);

        for (ParamValuePair pair : paramValues) {
            query.setParameter(pair.getParamName(), pair.getParamValue());
        }

        if (limit != null && offset != null) {
            query.setFirstResult(offset);
            query.setMaxResults(limit);
        }

        return query.getResultList();
    }

}
