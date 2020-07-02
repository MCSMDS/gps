package com.example.gpsapi;

import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.Looper;

import java.util.HashMap;
import java.util.Map;

class GpsHandler implements LocationListener {
    private final GpsapiPlugin gpsPlugin;
    private final LocationManager locationManager;

    GpsHandler(GpsapiPlugin gpsPlugin, LocationManager locationManager) {
        this.gpsPlugin = gpsPlugin;
        this.locationManager = locationManager;
    }

    void handleGps() {
        Criteria criteria = new Criteria();
        criteria.setAccuracy(Criteria.ACCURACY_FINE);
        criteria.setAltitudeRequired(false);
        criteria.setCostAllowed(true);
        locationManager.requestSingleUpdate(criteria, this, Looper.getMainLooper());
    }

    @Override
    public void onLocationChanged(Location location) {
        locationManager.removeUpdates(this);
        Map<String, Object> map = new HashMap<>();
        map.put("latitude", location.getLatitude());
        map.put("longitude", location.getLongitude());
        map.put("altitude",location.getAltitude());
        map.put("timestamp", location.getTime());
        gpsPlugin.setResult(map);
    }

    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {

    }

    @Override
    public void onProviderEnabled(String provider) {

    }

    @Override
    public void onProviderDisabled(String provider) {

    }
}