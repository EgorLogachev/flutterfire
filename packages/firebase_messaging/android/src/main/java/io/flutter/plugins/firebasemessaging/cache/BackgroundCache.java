package android.src.main.java.io.flutter.plugins.firebasemessaging.cache;

import android.content.Context;
import android.util.Log;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

public class BackgroundCache {
    private static final String FILE_NAME = "temporary_notifications_data_storage";

    private static final ObjectSerializer<ArrayList<HashMap<String, String>>> serializer  =
            new ObjectSerializer<ArrayList<HashMap<String, String>>>();

    public static ArrayList<HashMap<String, String>> get(Context context) {
        try {
            return serializer.read(context, FILE_NAME);
        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
            Log.d("NOTIFICATION SERIALIZER", "get messages error: " + e);
            return null;
        }
    }

    public static void put(Context context, ArrayList<HashMap<String, String>> notifications) {
        try {
            serializer.write(context, FILE_NAME, notifications);
        } catch (IOException e) {
            e.printStackTrace();
            Log.d("NOTIFICATION SERIALIZER", "put messages error: " + e);
        }
    }
}
