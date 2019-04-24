package ge.koaladev.msy.nso.core.services;

import ge.koaladev.msy.nso.core.dto.objects.EventDTO;
import ge.koaladev.msy.nso.core.dto.objects.UserDTO;
import ge.koaladev.msy.nso.database.model.Groups;
import org.springframework.stereotype.Service;

/**
 * Created by nl on 2/21/2016.
 */
@Service
public class ActionManagerService {

    public enum Action {
        EDIT,
        SEND,
        SEND_REPORT,
        DELETE,
        ACCOUNTANT,
        RETURN,
        APPROVE,
        DECISION_OK,
        REJECT,
        ADD_AMOUNT,
        DISPATCH,
        PROCCESS,
        SET_NUMBER,
        CLOSE
    }


    public boolean has(EventDTO event, UserDTO user, Action action) {
        if (user.getUsersGroup().getName().equals(Groups.FEDERATION.getName())) {
            if (action == Action.EDIT) {
                return (event.getLastStatus().getId() == 1 || event.getLastStatus().getId() == 2 || event.getLastStatus().getId() == 4) && event.getIteration() == 1;
            }
            if (action == Action.SEND) {
                return (event.getLastStatus().getId() == 1 || event.getLastStatus().getId() == 2 || (event.getLastStatus().getId() == 4 && event.getIteration() == 1));
            }
            if (action == Action.SEND_REPORT) {
                return (event.getLastStatus().getId() == 6 || (event.getLastStatus().getId() == 4 && event.getIteration() == 2));
            }
            if (action == Action.DELETE) {
                return (event.getLastStatus().getId() == 1);
            }
        }
        else if (user.getUsersGroup().getName().equals(Groups.SUPERVISOR.getName())) {
            if (action == Action.RETURN || action == Action.ACCOUNTANT) {
                return (event.getLastStatus().getStage() == 3 || (event.getLastStatus().getStage() == 9 && event.getLastUserId() == user.getId()));
            }
        }
        else if (user.getUsersGroup().getName().equals(Groups.ACCOUNTANT.getName())) {
            if (action == Action.RETURN || action == Action.APPROVE) {
                return (event.getLastStatus().getStage() == 10 || (event.getLastStatus().getStage() == 9 && event.getLastUserId() == user.getId()));
            }
        } else if (user.getUsersGroup().getName().equals(Groups.MANAGER.getName())) {
            if (action == Action.RETURN) {
                return (event.getLastStatus().getStage() == 12 || (event.getLastStatus().getStage() == 9 && event.getLastUserId() == user.getId()));
            }
            if (action == Action.REJECT) {
                return event.getIteration() == 1 && (event.getLastStatus().getStage() == 2 || event.getLastStatus().getStage() == 5 || event.getLastStatus().getStage() == 11 || event.getLastStatus().getStage() == 12 || (event.getLastStatus().getStage() == 9 && event.getLastUserId() == user.getId()));
            }
            if (action == Action.ADD_AMOUNT) {
                return (event.getIteration() == 2 &&(event.getLastStatus().getId() == 7 || event.getLastStatus().getId() == 5 || event.getLastStatus().getId() == 11));
            }
            if (action == Action.DISPATCH) {
                return (event.getLastStatus().getStage() == 2 || event.getLastStatus().getStage() == 5 || event.getLastStatus().getStage() == 11 || event.getLastStatus().getStage() == 12 || (event.getLastStatus().getStage() == 9 && event.getLastUserId() == user.getId()));
            }
            if (action == Action.PROCCESS) {
                return (event.getLastStatus().getStage() == 2 && event.getIteration() == 1);
            }
            if (action == Action.DECISION_OK) {
                return (event.getIteration() == 1 && (event.getLastStatus().getStage() == 5 || event.getLastStatus().getStage() == 11 || event.getLastStatus().getStage() == 12 || (event.getLastStatus().getStage() == 9 && event.getLastUserId() == user.getId())));
            }
            if (action == Action.CLOSE) {
                return (event.getIteration() == 2 && (event.getLastStatus().getId() == 11 || event.getLastStatus().getId() == 5));
            }
        }
         else if (user.getUsersGroup().getName().equals(Groups.CHANCELLERY.getName())) {
            if (action == Action.SET_NUMBER) {
                //TODO temporary
                return (event.getLastStatus().getId() == EventDTO.EVENT_STATUS_NEW);
               // return (event.getLastStatus().getStage() == EventDTO.EVENT_STATUS_APPROVED || event.getIteration()== EventDTO.EVENT_ITERATION_TWO);
            }
        }
        return false;
    }
}
