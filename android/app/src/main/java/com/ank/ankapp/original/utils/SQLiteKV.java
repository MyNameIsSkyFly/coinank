package com.ank.ankapp.original.utils;

/*
 * Tencent is pleased to support the open source community by making
 * MMKV available.
 *
 * Copyright (C) 2018 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.text.TextUtils;

public final class SQLiteKV {
    private static class SQLiteKVDBHelper extends SQLiteOpenHelper {
        private static final int DB_VERSION = 1;
        private static final String DB_NAME = "soto.db";
        public static final String TABLE_NAME_STR = "app_kv_str";
        public static final String TABLE_NAME_INT = "app_kv_int";

        public SQLiteKVDBHelper(Context context) {
            super(context, DB_NAME, null, DB_VERSION);
        }

        @Override
        public void onCreate(SQLiteDatabase sqLiteDatabase) {
            String sql =
                    "create table if not exists " + TABLE_NAME_STR + " (k text UNIQUE on conflict replace, v text)";
            sqLiteDatabase.execSQL(sql);
            sql = "create table if not exists " + TABLE_NAME_INT + " (k text UNIQUE on conflict replace, v integer)";
            sqLiteDatabase.execSQL(sql);
        }

        @Override
        public void onUpgrade(SQLiteDatabase sqLiteDatabase, int oldVersion, int newVersion) {
            String sql = "DROP TABLE IF EXISTS " + TABLE_NAME_STR;
            sqLiteDatabase.execSQL(sql);
            sql = "DROP TABLE IF EXISTS " + TABLE_NAME_INT;
            sqLiteDatabase.execSQL(sql);
            onCreate(sqLiteDatabase);
        }
    }
    private final SQLiteKVDBHelper m_dbHelper;
    private SQLiteDatabase m_writetableDB;
    private SQLiteDatabase m_readableDB;

    public SQLiteKV(Context context) {
        m_dbHelper = new SQLiteKVDBHelper(context);
        m_dbHelper.setWriteAheadLoggingEnabled(true);
    }

    public void beginTransaction() {
        getWritetableDB().beginTransaction();
    }

    public void endTransaction() {
        if (m_writetableDB != null) {
            try {
                m_writetableDB.setTransactionSuccessful();
            } finally {
                m_writetableDB.endTransaction();
            }
        }
    }

    private SQLiteDatabase getWritetableDB() {
        if (m_writetableDB == null) {
            m_writetableDB = m_dbHelper.getWritableDatabase();
        }
        return m_writetableDB;
    }

    private SQLiteDatabase getReadableDatabase() {
        if (m_readableDB == null) {
            m_readableDB = m_dbHelper.getReadableDatabase();
        }
        return m_readableDB;
    }

    @Override
    protected void finalize() throws Throwable {
        if (m_readableDB != null) {
            m_readableDB.close();
        }
        if (m_writetableDB != null) {
            m_writetableDB.close();
        }
        super.finalize();
    }

    public boolean putBoolean(String key, boolean value) {
        ContentValues contentValues = new ContentValues();
        contentValues.put("k", key);
        int val = 0;
        if (value) val = 1;
        contentValues.put("v", val);
        long rowID = getWritetableDB().insert(SQLiteKVDBHelper.TABLE_NAME_INT, null, contentValues);
        return rowID != -1;
    }

    public boolean getBoolean(String key, boolean defVal) {
        int value = 0;
        if (defVal) value = 1;

        Cursor cursor = getReadableDatabase().rawQuery(
                "select v from " + SQLiteKVDBHelper.TABLE_NAME_INT + " where k=?", new String[] {key});
        if (cursor.moveToFirst()) {
            value = cursor.getInt(cursor.getColumnIndex("v"));
        }
        cursor.close();

        return value != 0;
    }

    public boolean putInt(String key, int value) {
        ContentValues contentValues = new ContentValues();
        contentValues.put("k", key);
        contentValues.put("v", value);
        long rowID = getWritetableDB().insert(SQLiteKVDBHelper.TABLE_NAME_INT, null, contentValues);
        return rowID != -1;
    }

    public int getInt(String key) {
        int value = 0;
        Cursor cursor = getReadableDatabase().rawQuery(
                "select v from " + SQLiteKVDBHelper.TABLE_NAME_INT + " where k=?", new String[] {key});
        if (cursor.moveToFirst()) {
            value = cursor.getInt(cursor.getColumnIndex("v"));
        }
        cursor.close();
        return value;
    }

    public void async()
    {

    }

    public int getInt(String key, int defVal) {
        int value = defVal;
        Cursor cursor = getReadableDatabase().rawQuery(
                "select v from " + SQLiteKVDBHelper.TABLE_NAME_INT + " where k=?", new String[] {key});
        if (cursor.moveToFirst()) {
            value = cursor.getInt(cursor.getColumnIndex("v"));
        }
        cursor.close();
        return value;
    }

    public boolean putFloat(String key, float value) {
        ContentValues contentValues = new ContentValues();
        contentValues.put("k", key);
        contentValues.put("v", String.valueOf(value));
        long rowID = getWritetableDB().insert(SQLiteKVDBHelper.TABLE_NAME_STR, null, contentValues);
        return rowID != -1;
    }

    public float getFloat(String key, float defVal) {
        String value = null;
        Cursor cursor = getReadableDatabase().rawQuery(
                "select v from " + SQLiteKVDBHelper.TABLE_NAME_STR + " where k=?", new String[] {key});
        if (cursor.moveToFirst()) {
            value = cursor.getString(cursor.getColumnIndex("v"));
        }
        cursor.close();

        if (TextUtils.isEmpty(value))
            value = String.valueOf(defVal);
        return Float.parseFloat(value);
    }

    public boolean putLong(String key, long value) {
        ContentValues contentValues = new ContentValues();
        contentValues.put("k", key);
        contentValues.put("v", String.valueOf(value));
        long rowID = getWritetableDB().insert(SQLiteKVDBHelper.TABLE_NAME_STR, null, contentValues);
        return rowID != -1;
    }

    public long getLong(String key, long defVal) {
        String value = null;
        Cursor cursor = getReadableDatabase().rawQuery(
                "select v from " + SQLiteKVDBHelper.TABLE_NAME_STR + " where k=?", new String[] {key});
        if (cursor.moveToFirst()) {
            value = cursor.getString(cursor.getColumnIndex("v"));
        }
        cursor.close();

        if (TextUtils.isEmpty(value))
            value = String.valueOf(defVal);
        return Long.parseLong(value);
    }

    public boolean putString(String key, String value) {
        ContentValues contentValues = new ContentValues();
        contentValues.put("k", key);
        contentValues.put("v", value);
        long rowID = getWritetableDB().insert(SQLiteKVDBHelper.TABLE_NAME_STR, null, contentValues);
        return rowID != -1;
    }

    public String getString(String key) {
        String value = null;
        Cursor cursor = getReadableDatabase().rawQuery(
                "select v from " + SQLiteKVDBHelper.TABLE_NAME_STR + " where k=?", new String[] {key});
        if (cursor.moveToFirst()) {
            value = cursor.getString(cursor.getColumnIndex("v"));
        }
        cursor.close();
        return value;
    }

    public String getString(String key, String defVal) {
        String value = defVal;
        Cursor cursor = getReadableDatabase().rawQuery(
                "select v from " + SQLiteKVDBHelper.TABLE_NAME_STR + " where k=?", new String[] {key});
        if (cursor.moveToFirst()) {
            value = cursor.getString(cursor.getColumnIndex("v"));
        }
        cursor.close();
        return value;
    }
}

