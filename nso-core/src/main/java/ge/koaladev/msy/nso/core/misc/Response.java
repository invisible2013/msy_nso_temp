/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.misc;

import com.google.gson.Gson;

/**
 *
 * @author mindia
 */
public class Response extends JsonSerializable {

    private int errorCode;
    private String message;
    private Object data;

    private static final int SUCCESS = 0;

    public static Response ok() {
        Response r = new Response();
        r.setErrorCode(SUCCESS);
        return r;
    }

    public static Response withError(String error) {
        Response r = new Response();
        r.setErrorCode(700);
        r.setMessage(error);
        return r;
    }

    public static Response withError(int errorCode) {
        Response r = new Response();
        r.setErrorCode(errorCode);
        return r;
    }

    public static Response withSuccess(Object data) {
        Response r = ok();
        r.setData(data);
        return r;
    }

    public static Response makeSimpleData(Object data) {
        Response r = ok();
        r.setData(new SimpleData(data));
        return r;
    }

    public static String asJson(Response r) {
        return new Gson().toJson(r);
    }

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }

}

class SimpleData {

    private Object data;

    public SimpleData(Object data) {
        this.data = data;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }
}