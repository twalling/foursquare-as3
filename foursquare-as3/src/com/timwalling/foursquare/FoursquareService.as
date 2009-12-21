/*
 * Copyright (c) 2009 Tim Walling
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */
package com.timwalling.foursquare
{
    import flash.net.URLRequestMethod;
    
    /**
     * Service which uses the Foursquare API.
     */
    public class FoursquareService
    {
        /**
         * URL prefix to use for REST calls.
         */
        public var url:String = "http://api.foursquare.com/v1/";
        
        /**
         * The request format. <code>FoursquareRequestFormat.XML</code> or <code>FoursquareRequestFormat.JSON</code>.
         * 
         * @default <code>FoursquareRequestFormat.JSON</code>
         */
        public var format:String = FoursquareRequestFormat.JSON;
        
        /**
         * Request timeout in seconds. Value of -1 indicates no timeout.
         * 
         * @default -1
         */
        public var timeout:Number = -1;
        
        /* OAuth Exchange Method */
        
        /**
         * Returns an oauth token and secret for making API calls.
         * 
         * @param username Foursquare username
         * @param password Foursquare password
         */
        public function getAuthToken(username:String, password:String):FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "authexchange", {fs_username:username, fs_password:password});
            operation.timeout = timeout;
            operation.method = URLRequestMethod.POST;
            return operation;
        }
        
        /* Geo Methods */
        
        /**
         * Returns a list of currently active cities.
         */
        public function getCities():FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "cities" + format);
            operation.timeout = timeout;
            return operation;
        }
        
        /**
         * When given a lat/long, returns the closest foursquare city.
         * 
         * @param geolat latitude
         * @param geolong longitude
         */
        public function checkCity(geolat:String, geolong:String):FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "checkcity" + format, {geolat:geolat, geolong:geolong});
            operation.timeout = timeout;
            return operation;
        }
        
        /**
         * When given a valid foursquare cityid, changes the user's default city.
         * 
         * @param cityid A foursquare cityid to which you want to switch
         */
        public function switchCity(cityid:String):FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "switchcity" + format, {cityid:cityid});
            operation.timeout = timeout;
            operation.method = URLRequestMethod.POST;
            operation.requiresAuth = true;
            return operation;
        }
        
        /* Checkin Methods */
        
        /**
         * Returns a list of recent checkins from friends.
         * 
         * @param geolat latitude (optional, but recommended)
         * @param geolong longitude (optional, but recommended)
         * @param cityid A foursquare cityid from which to retrieve checkin history (optional, not recommended)
         */
        public function getCheckins(geolat:String = "", geolong:String = "", cityid:String = ""):FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "checkins" + format, {geolat:geolat, geolong:geolong, cityid:cityid});
            operation.timeout = timeout;
            operation.requiresAuth = true;
            return operation;
        }
        
        /**
         * Allows you to check-in to a place.
         * 
         * @param geolat latitude (optional, but recommended)
         * @param geolong longitude (optional, but recommended)
         * @param vid ID of the venue where you want to check-in (optional, not necessary if you are 'shouting' or have a venue name)
         * @param venue if you don't have a venue ID, pass the venue name as a string using this parameter. foursquare will attempt to match it on the server-side (optional, not necessary if you are 'shouting' or have a vid)
         * @param shout a message about your check-in. the maximum length of this field is 140 characters (optional)
         * @param secret "1" means "don't show your friends". "0" means "show everyone" (optional)
         * @param twitter "1" means "send to Twitter". "0" means "don't send to Twitter" (optional, defaults to the user's setting)
         * @param facebook "1" means "send to Facebook". "0" means "don't send to Facebook" (optional, defaults to the user's setting)
         */
        public function checkin(geolat:String = "", geolong:String = "", vid:String = "", venue:String = "", shout:String = "", secret:String = "", twitter:String = "", facebook:String = ""):FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "checkin" + format, {geolat:geolat, geolong:geolong, vid:vid, venue:venue, shout:shout, "private":secret, twitter:twitter, facebook:facebook});
            operation.timeout = timeout;
            operation.method = URLRequestMethod.POST;
            operation.requiresAuth = true;
            return operation;
        }
        
        /**
         * Returns a history of checkins for the authenticated user (across all cities).
         * 
         * @param limit limit of results (optional, default is 20)
         * @param sinceid id to start returning results from (optional, if omitted returns most recent results)
         */
        public function getHistory(limit:Number = 20, sinceid:String = ""):FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "history" + format, {l:limit, sinceid:sinceid});
            operation.timeout = timeout;
            operation.requiresAuth = true;
            return operation;
        }
        
        /* User Methods */
        
        /**
         *
         */
        public function getUserDetails():FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "user" + format, {});
            operation.timeout = timeout;
            operation.requiresAuth = true;
            return operation;
        }
        
        /**
         * 
         */
        public function getFriends():FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "friends" + format, {});
            operation.timeout = timeout;
            operation.requiresAuth = true;
            return operation;
        }
        
        /* Venue Methods */
        
        /**
         * Returns a list of venues near the area specified or that match the search term.
         * 
         * @param geolat latitude
         * @param geolong longitude
         * @param limit Limit of results (optional, default is 10)
         * @param keyword keyword to use when searching (optional)
         */
        public function findVenues(geolat:String, geolong:String, limit:int = 10, keyword:String = ""):FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "venues" + format, {geolat:geolat, geolong:geolong, l:limit, q:keyword});
            operation.timeout = timeout;
            return operation;
        }
        
        /**
         * Returns venue data, including mayorship, tips/to-dos and tags.
         * 
         * @param vid The ID for the venue for which you want information 
         */
        public function getVenueDetails(vid:String):FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "venue" + format, {vid:vid});
            operation.timeout = timeout;
            return operation;
        }
        
        /**
         * 
         */
        public function addVenue():FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "addvenue" + format, {});
            operation.timeout = timeout;
            operation.method = URLRequestMethod.POST;
            operation.requiresAuth = true;
            return operation;
        }
        
        /**
         * 
         */
        public function proposeVenueEdit():FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "venue/proposeedit" + format, {});
            operation.timeout = timeout;
            operation.method = URLRequestMethod.POST;
            operation.requiresAuth = true;
            return operation;
        }
        
        /**
         * 
         */
        public function flagVenueClosed():FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "venue/flagclosed" + format, {});
            operation.timeout = timeout;
            operation.method = URLRequestMethod.POST;
            operation.requiresAuth = true;
            return operation;
        }
        
        /* Tip Methods */
        
        /**
         * Returns a list of tips near the area specified. (The distance returned is in meters).
         * 
         * @param geolat latitude
         * @param longitude longitude
         * @param limit limit of results (optional, default is 30)
         */
        public function findTips(geolat:String, geolong:String, limit:int = 30):FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "tips" + format, {geolat:geolat, geolong:geolong, l:limit});
            operation.timeout = timeout;
            return operation;
        }
        
        /**
         * 
         */
        public function addTip():FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "addtip" + format, {});
            operation.timeout = timeout;
            operation.method = URLRequestMethod.POST;
            operation.requiresAuth = true;
            return operation;
        }
        
        /**
         * 
         */
        public function markTipAsToDo():FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "tip/marktodo" + format, {});
            operation.timeout = timeout;
            operation.method = URLRequestMethod.POST;
            operation.requiresAuth = true;
            return operation;
        }
        
        /**
         * 
         */
        public function markTipAsDone():FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "tip/markdone" + format, {});
            operation.timeout = timeout;
            operation.method = URLRequestMethod.POST;
            operation.requiresAuth = true;
            return operation;
        }
        
        /* Friend Methods */
        
        /**
         * 
         */
        public function getFriendRequests():FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "friend/requests" + format, {});
            operation.timeout = timeout;
            operation.requiresAuth = true;
            return operation;
        }
        
        /**
         * 
         */
        public function approveFriendRequest():FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "friend/approve" + format, {});
            operation.timeout = timeout;
            operation.method = URLRequestMethod.POST;
            operation.requiresAuth = true;
            return operation;
        }
        
        /**
         * 
         */
        public function denyFriendRequest():FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "friend/deny" + format, {});
            operation.timeout = timeout;
            operation.method = URLRequestMethod.POST;
            operation.requiresAuth = true;
            return operation;
        }
        
        /**
         * 
         */
        public function sendFriendRequest():FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "friend/sendrequest" + format, {});
            operation.timeout = timeout;
            operation.method = URLRequestMethod.POST;
            operation.requiresAuth = true;
            return operation;
        }
        
        /**
         * 
         */
        public function findFriendsByName():FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "findfriends/byname" + format, {});
            operation.timeout = timeout;
            operation.requiresAuth = true;
            return operation;
        }
        
        /**
         * 
         */
        public function findFriendsByPhone():FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "findfriends/byphone" + format, {});
            operation.timeout = timeout;
            operation.requiresAuth = true;
            return operation;
        }
        
        /**
         * 
         */
        public function findFriendsByTwitter():FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "findfriends/bytwitter" + format, {});
            operation.timeout = timeout;
            operation.requiresAuth = true;
            return operation;
        }
        
        /* Settings Methods */
        
        /**
         * 
         */
        public function setPings():FoursquareOperation
        {
            var operation:FoursquareOperation = new FoursquareOperation(url + "settings/setpings" + format, {});
            operation.timeout = timeout;
            operation.method = URLRequestMethod.POST;
            operation.requiresAuth = true;
            return operation;
        }
    }
}