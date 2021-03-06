package com.appirio.mobile.plugins;

import java.util.Calendar;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.DatePickerDialog;
import android.app.DatePickerDialog.OnDateSetListener;
import android.app.TimePickerDialog;
import android.app.TimePickerDialog.OnTimeSetListener;
import android.content.DialogInterface;
import android.content.DialogInterface.OnCancelListener;
import android.content.DialogInterface.OnDismissListener;
import android.util.Log;
import android.widget.DatePicker;
import android.widget.TimePicker;


import org.apache.cordova.DroidGap;
import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;

public class AMTimePicker extends Plugin {

	private static final String ACTION_DATE = "date";
	private static final String ACTION_TIME = "time";
	private final String pluginName = "DatePickerPlugin";

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.phonegap.api.Plugin#execute(java.lang.String,
	 * org.json.JSONArray, java.lang.String)
	 */
	@Override
	public PluginResult execute(final String action, final JSONArray data, final String callBackId) {
		Log.d(pluginName, "DatePicker called with options: " + data);
		PluginResult result = null;

		this.show(data, callBackId);
		result = new PluginResult(PluginResult.Status.NO_RESULT);
		result.setKeepCallback(true);

		return result;
	}

	public synchronized void show(final JSONArray data, final String callBackId) {
		final AMTimePicker datePickerPlugin = this;
		final DroidGap currentCtx = (DroidGap) ctx.getContext();
		final Calendar c = Calendar.getInstance();
		final Runnable runnable;

		String action = "date";

		/*
		 * Parse information from data parameter and where possible, override
		 * above date fields
		 */
		int month = -1, day = -1, year = -1, hour = -1, min = -1;
		try {
			JSONObject obj = data.getJSONObject(0);
			action = obj.getString("mode");

			String optionDate = obj.getString("date");

			String[] datePart = optionDate.split("/");
			month = Integer.parseInt(datePart[0]);
			day = Integer.parseInt(datePart[1]);
			year = Integer.parseInt(datePart[2]);
			hour = Integer.parseInt(datePart[3]);
			min = Integer.parseInt(datePart[4]);

			/* currently not handled in Android */
			// boolean optionAllowOldDates = obj.getBoolean("allowOldDates");

		} catch (JSONException e) {
			e.printStackTrace();
		}

		// By default initalize these fields to 'now'
		final int mYear = year == -1 ? c.get(Calendar.YEAR) : year;
		final int mMonth = month == -1 ? c.get(Calendar.MONTH) : month - 1;
		final int mDay = day == -1 ? c.get(Calendar.DAY_OF_MONTH) : day;
		final int mHour = hour == -1 ? c.get(Calendar.HOUR_OF_DAY) : hour;
		final int mMinutes = min == -1 ? c.get(Calendar.MINUTE) : min;

		if (ACTION_TIME.equalsIgnoreCase(action)) {
			runnable = new Runnable() {
				public void run() {
					final TimeSetListener timeSetListener = new TimeSetListener(datePickerPlugin, callBackId);
					final TimePickerDialog timeDialog = new TimePickerDialog(currentCtx, timeSetListener, mHour,
							mMinutes, false);
					
					timeDialog.setOnDismissListener(new DismissListener(datePickerPlugin, callBackId));
					
					timeDialog.show();
				}
			};

		} else if (ACTION_DATE.equalsIgnoreCase(action)) {
			runnable = new Runnable() {
				public void run() {
					final DateSetListener dateSetListener = new DateSetListener(datePickerPlugin, callBackId);
					final DatePickerDialog dateDialog = new DatePickerDialog(currentCtx, dateSetListener, mYear,
							mMonth, mDay);
					dateDialog.show();
				}
			};

		} else {
			Log.d(pluginName, "Unknown action. Only 'date' or 'time' are valid actions");
			return;
		}

		ctx.runOnUiThread(runnable);
	}

	private final class DateSetListener implements OnDateSetListener {
		private final AMTimePicker datePickerPlugin;
		private final String callBackId;

		private DateSetListener(AMTimePicker datePickerPlugin, String callBackId) {
			this.datePickerPlugin = datePickerPlugin;
			this.callBackId = callBackId;
		}

		/**
		 * Return a string containing the date in the format YYYY/MM/DD
		 */
		public void onDateSet(final DatePicker view, final int year, final int monthOfYear, final int dayOfMonth) {
			String returnDate = year + "/" + (monthOfYear + 1) + "/" + dayOfMonth;
			datePickerPlugin.success(new PluginResult(PluginResult.Status.OK, returnDate), callBackId);

		}
	}

	private final class TimeSetListener implements OnTimeSetListener {
		private final AMTimePicker datePickerPlugin;
		private final String callBackId;

		private TimeSetListener(AMTimePicker datePickerPlugin, String callBackId) {
			this.datePickerPlugin = datePickerPlugin;
			this.callBackId = callBackId;
		}

		/**
		 * Return the current date with the time modified as it was set in the
		 * time picker.
		 */
		public void onTimeSet(final TimePicker view, final int hourOfDay, final int minute) {
			Date date = new Date();
			date.setHours(hourOfDay);
			date.setMinutes(minute);

			datePickerPlugin.success(new PluginResult(PluginResult.Status.OK, date.toLocaleString()), callBackId);

		}
	}
	
	private final class DismissListener implements OnDismissListener {
		private final AMTimePicker datePickerPlugin;
		private final String callBackId;

		private DismissListener(AMTimePicker datePickerPlugin, String callBackId) {
			this.datePickerPlugin = datePickerPlugin;
			this.callBackId = callBackId;
		}

		@Override
		public void onDismiss(DialogInterface dialog) {
			datePickerPlugin.success(new PluginResult(PluginResult.Status.OK, "cancelled"), this.callBackId);
		}
	}
	
}
