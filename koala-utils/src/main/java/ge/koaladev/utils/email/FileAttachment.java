package ge.koaladev.utils.email;

import java.io.File;

/**
 * Created by mindia on 7/11/16.
 */
public class FileAttachment {

    private String name;
    private String path;
    private File file;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public File getFile() {
        return file;
    }

    public void setFile(File file) {
        this.file = file;
    }
}
