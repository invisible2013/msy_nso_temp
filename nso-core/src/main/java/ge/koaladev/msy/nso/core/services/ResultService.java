package ge.koaladev.msy.nso.core.services;

import ge.koaladev.msy.nso.core.dao.CalendarDao;
import ge.koaladev.msy.nso.core.dao.ResultDao;
import ge.koaladev.msy.nso.core.dto.admin.AddCalendarRequest;
import ge.koaladev.msy.nso.core.dto.admin.AddResultRequest;
import ge.koaladev.msy.nso.core.dto.admin.GetCalendarRequest;
import ge.koaladev.msy.nso.core.dto.admin.GetResultRequest;
import ge.koaladev.msy.nso.core.dto.objects.CalendarDTO;
import ge.koaladev.msy.nso.core.dto.objects.ResultDTO;
import ge.koaladev.msy.nso.core.dto.objects.UserDTO;
import ge.koaladev.msy.nso.database.model.*;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.Date;
import java.util.List;

/**
 * Created by NINO on 4/2/2018.
 */

@Service
public class ResultService {

    @Autowired
    private ResultDao resultDao;


    private static final Logger logger = Logger.getLogger(ResultService.class);


    @Transactional
    public ResultDTO createResult(AddResultRequest request) {

        Result item = new Result();
        item.setId(request.getId());
        if (request.getId() == null || request.getId() == 0) {
        } else {
            item = resultDao.find(Result.class, request.getId());
        }

        item.setCategory(request.getCategory());
        item.setCreateDate(new Date());
        item.setUserId(request.getUserId());
        item.setSportsmanId(request.getSportsmanId());
        item.setChampionshipId(request.getChampionshipId());
        item.setScore(request.getScore());
        item.setDiscipline(request.getDiscipline());
        item.setAwardId(request.getAwardId());
        item.setNote(request.getNote());
        item = resultDao.update(item);

        return ResultDTO.parse(item);
    }


    @Transactional
    public List<ResultDTO> getResult(GetResultRequest request) {
        List<Result> results = resultDao.getResult(request.getUserId(), request.getFullText(), request.getLimit(), request.getOffset());
        return (results != null ? ResultDTO.parseToList(results) : null);
    }

    @Transactional
    public void deleteResult(int itemId) {
        Result result = resultDao.find(Result.class, itemId);
        if (result != null) {
            resultDao.delete(result);
        }
    }


}
