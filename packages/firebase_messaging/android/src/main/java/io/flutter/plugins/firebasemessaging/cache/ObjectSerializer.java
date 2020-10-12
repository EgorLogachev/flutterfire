package android.src.main.java.io.flutter.plugins.firebasemessaging.cache;

import android.content.Context;

import androidx.annotation.Nullable;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;

class ObjectSerializer<T extends Serializable> {
    @Nullable
    public synchronized T read(Context context, String fileName) throws IOException, ClassNotFoundException {
        T obj;
        try (FileInputStream fis = context.openFileInput(fileName);
             ObjectInputStream is = new ObjectInputStream(fis)) {
            obj = (T) is.readObject();
        }
        return obj;
    }

    public synchronized void write(Context context, String fileName, T obj) throws IOException {
        try (FileOutputStream fos = context.openFileOutput(fileName, Context.MODE_PRIVATE);
             ObjectOutputStream os = new ObjectOutputStream(fos)) {
            os.writeObject(obj);
        }
    }
}
