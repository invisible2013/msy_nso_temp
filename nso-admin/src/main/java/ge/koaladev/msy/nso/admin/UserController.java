package ge.koaladev.msy.nso.admin;

import ge.koaladev.core.security.HasRight;
import ge.koaladev.core.security.api.User;
import ge.koaladev.core.security.auth.AuthInterceptor;
import ge.koaladev.msy.nso.core.dto.admin.*;
import ge.koaladev.msy.nso.core.dto.objects.UserDTO;
import ge.koaladev.msy.nso.core.misc.Response;
import ge.koaladev.msy.nso.core.services.UsersService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@RequestMapping({"/users"})
@Controller

public class UserController {
    @Autowired
    private UsersService usersService;

    @RequestMapping({"/get-users"})
    @ResponseBody
    @HasRight("admin")
    private Response getUsers() {
        return Response.withSuccess(this.usersService.getUsers());
    }

    @RequestMapping({"/get-user"})
    @ResponseBody
    private Response getUser(HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        return Response.withSuccess(user.getUserData());
    }

    @RequestMapping({"/get-user-by-id"})
    @ResponseBody
    private Response getUserById(@RequestParam int userId) {
        return Response.withSuccess(usersService.getUser(userId));
    }

    @RequestMapping({"/get-users-by-group"})
    @ResponseBody
    private Response getUsersByGroup(@RequestBody GetUserByGroupRequest getUserByGroupRequest) {
        return Response.withSuccess(this.usersService.getUsersByGroup(getUserByGroupRequest.getGroupId()));
    }

    @RequestMapping({"/get-users-by-supervisor"})
    @ResponseBody
    private Response getUsersBySupervisors(HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        return Response.withSuccess(usersService.getUsersBySupervisor(u.getId()));
    }

    @RequestMapping({"/get-users-by-manager"})
    @ResponseBody
    private Response getUsersByManager(HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        return Response.withSuccess(usersService.getUsersByManager(u.getId()));
    }

    @RequestMapping({"/get-user-groups"})
    @ResponseBody
    private Response getUserGroups() {
        return Response.withSuccess(this.usersService.getUserGroups());
    }

    @RequestMapping({"/get-user-statuses"})
    @ResponseBody
    private Response getUserStatuses() {
        return Response.withSuccess(this.usersService.getUsersStatuses());
    }

    @RequestMapping({"/add-user"})
    @ResponseBody
    private Response addUser(@RequestBody AddUserRequest addUserRequest) {
        return Response.withSuccess(usersService.addUser(addUserRequest));
    }

    @ResponseBody
    @RequestMapping({"/add-user-image"})
    public Response addUserImage(@RequestParam("userId") String userId, @RequestParam(value = "files", required = false) MultipartFile[] files) {
        AddUserRequest request = new AddUserRequest();
        request.setId(Integer.parseInt(userId));
        usersService.addUserImage(request, files);
        return Response.ok();
    }

    @RequestMapping({"/add-user-budget"})
    @ResponseBody
    @HasRight("admin")
    private Response addUserBudget(@RequestBody AddUserBudgetRequest addUserBudgetRequest) {
        return Response.withSuccess(this.usersService.addUserBudget(addUserBudgetRequest));
    }

    @RequestMapping({"/get-user-budget"})
    @ResponseBody
    @HasRight("admin")
    private Response getUserBudget(@RequestBody GetUserBudgetRequest getUserBudgetRequest) {
        return Response.withSuccess(this.usersService.getUserBudget(getUserBudgetRequest.getUserId()));
    }

    @RequestMapping({"/get-user-budget-by-year"})
    @ResponseBody
    private Response getUserBudget(@RequestBody GetUserBudgetByYearRequest getUserBudgetByYearRequest) {
        return Response.withSuccess(this.usersService.getUserBudgetByYear(getUserBudgetByYearRequest.getUserId(), getUserBudgetByYearRequest.getYearId()));
    }

    @RequestMapping({"/delete-user-budget"})
    @ResponseBody
    private Response deleteUserBudget(@RequestBody DeleteUserBudgetRequest deleteUserBudgetRequest) {
        this.usersService.deleteUserBudget(deleteUserBudgetRequest.getUserId());
        return Response.ok();
    }
}
