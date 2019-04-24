package ge.koaladev.msy.nso.core.services;

import ge.koaladev.msy.nso.core.dao.UserDao;
import ge.koaladev.msy.nso.core.dao.UsersGroupDAO;
import ge.koaladev.msy.nso.core.dto.admin.AddUserBudgetRequest;
import ge.koaladev.msy.nso.core.dto.admin.AddUserRequest;
import ge.koaladev.msy.nso.core.dto.objects.UserBudgetDTO;
import ge.koaladev.msy.nso.core.dto.objects.UserDTO;
import ge.koaladev.msy.nso.core.dto.objects.UsersGroupDTO;
import ge.koaladev.msy.nso.core.dto.objects.UsersStatusDTO;
import ge.koaladev.msy.nso.core.services.file.FileService;
import ge.koaladev.msy.nso.database.misc.ParamValuePair;
import ge.koaladev.msy.nso.database.model.*;
import ge.koaladev.utils.MD5Provider;
import ge.koaladev.utils.datetime.YearFirstLastDayPair;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
public class UsersService {
    @Autowired
    private UserDao userDao;
    @Autowired
    private UsersGroupDAO usersGroupDao;
    @Autowired
    private SmsService smsService;
    @Autowired
    private FileService fileService;

    public List<UserDTO> getUsers() {
        return UserDTO.parseToList(this.userDao.getAll(Users.class), true);
    }

    public List<UserDTO> getUsersByGroup(int groupId) {
        List<Users> results = userDao.getUsersByGroup(groupId);
        return results != null ? UserDTO.parseToList(results, true) : null;
    }

    public List<UserDTO> getUsersBySupervisor(int supervisorId) {
        List<Users> results = userDao.getUsersBySupervisor(supervisorId);
        return results != null ? UserDTO.parseToList(results, true) : null;
    }

    public List<UserDTO> getUsersByManager(int managerId) {
        List<Users> results = userDao.getUsersByManager(managerId);
        return results != null ? UserDTO.parseToList(results, true) : null;
    }

    public List<UsersGroupDTO> getUserGroups() {
        return UsersGroupDTO.parseToList(this.usersGroupDao.getAll(UsersGroup.class), false);
    }

    @Transactional
    public List<UsersStatusDTO> getUsersStatuses() {
        return UsersStatusDTO.parseToList(this.userDao.getAll(UsersStatus.class));
    }

    @Transactional
    public UserDTO addUser(AddUserRequest addUserRequest) {
        Users user = new Users();
        user.setId(addUserRequest.getId());
        user.setIdNumber(addUserRequest.getIdNumber());
        user.setName(addUserRequest.getName());
        user.setAddress(addUserRequest.getAddress());
        user.setPhone(addUserRequest.getPhone());
        user.setPhone2(addUserRequest.getPhone2());
        user.setEmail(addUserRequest.getEmail());
        user.setSupervisorId(addUserRequest.getSupervisorId());
        user.setManagerId(addUserRequest.getManagerId());
        user.setUsersGroup((UsersGroup) this.userDao.find(UsersGroup.class, Integer.valueOf(addUserRequest.getUserGroupId())));
        user.setUsersStatus((UsersStatus) this.userDao.find(UsersStatus.class, Integer.valueOf(addUserRequest.getUserStatusId())));
        if (addUserRequest.getPassword() != null) {
            user.setPassword(MD5Provider.doubleMd5(addUserRequest.getPassword()));
        }
        if (user.getId() != null) {
            if (addUserRequest.getPassword() == null) {
                Users u = (Users) this.userDao.find(Users.class, user.getId());
                user.setPassword(u.getPassword());
            }
            user = (Users) this.userDao.update(user);
        } else {
            user = (Users) this.userDao.create(user);
        }
        return UserDTO.parse(user, true);
    }


    @Transactional
    public UserDTO addUserImage(AddUserRequest addUserRequest, MultipartFile[] files) {
        Users user = userDao.find(Users.class, addUserRequest.getId());
        if (files != null && files.length > 0) {
            MultipartFile file = files[0];
            String[] fileParts = file.getOriginalFilename().split("\\.");
            String fileExtension = fileParts.length > 1 ? fileParts[fileParts.length - 1] : "";
            String fileName = "u_" + 3 + "_" + UUID.randomUUID() + (fileExtension.length() > 0 ? ("." + fileExtension) : "");

            String fullPath = fileService.getRootDir() + "/" + fileName;

            File f = new File(fullPath);
            try {
                file.transferTo(f);
                user.setUrl(fileName);
            } catch (Exception ex) {

            }
        }
        user = (Users) userDao.update(user);
        return UserDTO.parse(user, true);
    }

    @Transactional
    public void deleteUser(int itemId) {
        Users item = (Users) this.userDao.find(Users.class, Integer.valueOf(itemId));
        if (item != null) {
            this.userDao.delete(item);
        }
    }

    @Transactional
    public UserBudgetDTO addUserBudget(AddUserBudgetRequest addUserRequest) {
        UserBudget user = new UserBudget();
        user.setId(addUserRequest.getId());
        user.setUserId(Integer.valueOf(addUserRequest.getUserId()));
        user.setBudget(addUserRequest.getBudget());
        if (user.getId() != null) {
            user = (UserBudget) this.userDao.update(user);
        } else {
            user = (UserBudget) this.userDao.create(user);
        }
        return UserBudgetDTO.parse(user);
    }

    @Transactional
    public void deleteUserBudget(int userId) {
        UserBudget item = (UserBudget) this.userDao.find(UserBudget.class, Integer.valueOf(userId));
        if (item != null) {
            this.userDao.delete(item);
        }
    }

    public List<UserBudgetDTO> getUserBudget(int userId) {
        List<UserBudget> results = this.userDao.getUserBudget(userId);
        return results != null ? UserBudgetDTO.parseToList(results) : null;
    }

    public Double getUserBudgetByYear(Integer userId, Integer yearId) {
        Date startDate = null;
        Date endDate = null;
        if (yearId != null) {
            YearFirstLastDayPair yearFirstLastDayPair = new YearFirstLastDayPair(yearId.intValue());
            startDate = yearFirstLastDayPair.getFirstDay();
            endDate = yearFirstLastDayPair.getLastDay();
        }
        List<Event> results = this.userDao.getUserBudgetByYear(userId.intValue(), startDate, endDate);
        Double sumBudget = Double.valueOf(0.0D);
        for (Event e : results) {
            if (e.getBudget() != null) {
                sumBudget = Double.valueOf(sumBudget.doubleValue() + e.getBudget().doubleValue());
            }
        }
        return sumBudget;
    }

    public UserDTO getUser(int userId) {
        Users user = userDao.find(Users.class, userId);
        return UserDTO.parse(user, true);
    }

    public UserDTO login(String email, String password) {
        List<ParamValuePair> paramValuePairs = new ArrayList();
        paramValuePairs.add(new ParamValuePair("email", email));
        paramValuePairs.add(new ParamValuePair("password", MD5Provider.doubleMd5(password)));

        List<Users> users = this.userDao.getAllByParamValue(Users.class, paramValuePairs);

        Users u = (users != null) && (!users.isEmpty()) ? (Users) users.get(0) : null;
        return u != null ? UserDTO.parse(u, true) : null;
    }

    public UserDTO loginWithPinCode(String email, String password, String pinCode) {
        List<ParamValuePair> paramValuePairs = new ArrayList();
        paramValuePairs.add(new ParamValuePair("email", email));
        paramValuePairs.add(new ParamValuePair("password", MD5Provider.doubleMd5(password)));
        paramValuePairs.add(new ParamValuePair("pinCode", pinCode));

        List<Users> users = this.userDao.getAllByParamValue(Users.class, paramValuePairs);

        Users u = (users != null) && (!users.isEmpty()) ? (Users) users.get(0) : null;
        return u != null ? UserDTO.parse(u, true) : null;
    }

    @Transactional
    public boolean sendTwoStepVerificationCode(int userId) {
        Users users = (Users) this.userDao.find(Users.class, Integer.valueOf(userId));

        String pin = generatePIN();
        if (smsService.sendOneTimePassword(users.getPhone(), pin)) {
            if (users.getPhone2() != null && users.getPhone2().length() > 0) {
                smsService.sendOneTimePassword(users.getPhone2(), pin);
            }
            users.setPinCode(pin);
            userDao.update(users);
            return true;
        }
        return false;
    }

    public String generatePIN() {
        int x = (int) (Math.random() * 9.0D);
        x += 1;
        String randomPIN = x + "" + (int) (Math.random() * 1000.0D) + "";
        return randomPIN;
    }
}
