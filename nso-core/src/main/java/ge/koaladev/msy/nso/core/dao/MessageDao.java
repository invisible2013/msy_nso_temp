package ge.koaladev.msy.nso.core.dao;

import ge.koaladev.msy.nso.core.dto.objects.MessageDTO;
import ge.koaladev.msy.nso.core.dto.objects.MessageHistoryDTO;
import ge.koaladev.msy.nso.database.model.AbstractDAO;
import ge.koaladev.msy.nso.database.model.Message;
import ge.koaladev.msy.nso.database.model.MessageHistory;
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
public class MessageDao extends AbstractDAO<Message> {

    @PersistenceContext(unitName = "nso")
    private EntityManager entityManager;

    @Override
    public EntityManager getEntityManager() {
        return entityManager;
    }

    @Transactional
    public List<Message> getMessageByStatus(Integer userId, Integer statusId, String fullTextSearch, Integer limit, Integer offset, boolean isFederation) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(Message.class.getSimpleName()).append(" e Where 1=1 ");
        if (statusId != null) {
            if (statusId == 1) {
                q.append(" and e.status.id in(1,3) ");
            } else {
                q.append(" and e.status.id = ").append(statusId);
            }
        }
        if (fullTextSearch != null) {
            StringBuilder f = new StringBuilder();
            f.append(" and ( ");

            f.append("( e.name like '%" + fullTextSearch + "%' ) ");
            f.append("or ( e.description like '%" + fullTextSearch + "%' ) ");
            f.append("or ( e.number like '%" + fullTextSearch + "%' ) ");
            f.append("or ( e.receiverUser.name like '%" + fullTextSearch + "%' ) ");

            f.append(" ) ");

            q.append(f.toString());
        }
        if (isFederation) {
            q.append(" and e.receiverUser.id = ").append(userId);
        }
        q.append(" order by e.id desc ");
        TypedQuery<Message> query = entityManager.createQuery(q.toString(), Message.class);

        if (limit != null && offset != null) {
            query.setFirstResult(offset);
            query.setMaxResults(limit);
        }

        return query.getResultList();
    }

    public List<MessageHistoryDTO> getMessageHistory(int messageId) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(MessageHistory.class.getSimpleName()).append(" e Where e.messageId = ").append(messageId);

        TypedQuery<MessageHistory> query = entityManager.createQuery(q.toString(), MessageHistory.class);
        List<MessageHistory> result = query.getResultList();
        return result != null ? MessageHistoryDTO.parseToList(result) : null;
    }

    @Transactional
    public List<Message> getBlockedMessagesByUserId(int userId) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(Message.class.getSimpleName()).append(" e Where e.receiverUser.id =").append(userId);
        q.append(" and e.status.id =").append(MessageDTO.MESSAGE_STATUS_BLOCKED);
        TypedQuery<Message> query = entityManager.createQuery(q.toString(), Message.class);
        return query.getResultList();
    }
}
