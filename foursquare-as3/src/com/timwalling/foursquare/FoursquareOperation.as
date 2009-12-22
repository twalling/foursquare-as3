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
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.TimerEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import flash.utils.Timer;
    
    [Event(name="complete",type="flash.events.Event")]
    [Event(name="error",type="flash.events.ErrorEvent")]
    
    /**
     * Operation class which performs URL request for API calls.
     */
    public class FoursquareOperation
        extends EventDispatcher
    {
        private var _data:Object;
        private var _loader:URLLoader;
        private var _tim:Timer;
        
        /**
         * The URL of the request.
         */
        public var url:String;
        
        /**
         * The params to pass along in the URL request.
         */
        public var params:Object;
        
        /**
         * Boolean indicating whether the operation requires authentication.
         */
        public var requiresAuth:Boolean = false;
        
        /**
         * HTTP method for sending the request. Permitted values are
         * GET and POST.
         * 
         * @default <code>URLRequestMethod.GET</code>
         */
        public var method:String = URLRequestMethod.GET;
        
        /**
         * Request timeout in seconds. Value of -1 indicates no timeout.
         * 
         * @default -1
         */
        public var timeout:Number = -1;
        
        /**
         * The data loaded from the URL request.
         */
        public function get data():*
        {
            return _data;
        }
        
        /**
         * Constructor
         */
        public function FoursquareOperation(url:String, params:Object = null)
        {
            this.url = url;
            this.params = params;
        }
        
        /**
         * Initiates the operation.
         */
        public function execute():void
        {
            if (requiresAuth)
            {
                handleError(new ErrorEvent(ErrorEvent.ERROR, false, false, "Need to provide auth credentials for this operation."));
                return;
            }
            
            var request:URLRequest = new URLRequest(url);
            request.method = method;
            
            var isVarsEmpty:Boolean = true;
            var vars:URLVariables;
            if (params)
            {
                vars = new URLVariables();
                for (var prop:String in params)
                {
                    if (params[prop] != "" && params[prop] != null)
                    {
                    	isVarsEmpty = false;
                        vars[prop] = params[prop];
                    }
                }
                request.data = vars;
            }
            
            // this is used to ensure that the request method remains
            // a POST, if there are no variables to post then Flash
            // automatically changes the request to a GET
            if (request.method == URLRequestMethod.POST && isVarsEmpty)
            {
                vars = new URLVariables();
                vars.dummy = "";
                request.data = vars;
            }
            
            _loader = new URLLoader();
            _loader.addEventListener(Event.COMPLETE, handleLoaderComplete);
            _loader.addEventListener(IOErrorEvent.IO_ERROR, handleLoaderError);
            _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleLoaderError);
            _loader.load(request);
            
            if (timeout && timeout != -1)
            {
                _tim = new Timer(timeout * 1000, 1);
                _tim.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimeout);
                _tim.start();
            }
        }
        
        /**
         * Handles a timeout.
         */
        private function handleTimeout(event:TimerEvent):void
        {
            _loader.close();
            handleError(new ErrorEvent(ErrorEvent.ERROR, false, false, "Request timed out. URL requested: " + url));
        }
        
        /**
         * @private
         */
        private function handleLoaderError(event:ErrorEvent):void
        {
            stopTimer();
            removeLoaderEventListeners();
            handleError(new ErrorEvent(ErrorEvent.ERROR, false, false, event.text));
        }
        
        /**
         * Handles the result of the loader.
         */
        private function handleLoaderComplete(event:Event):void
        {
            stopTimer();
            _data = _loader.data;
            removeLoaderEventListeners();
            handleComplete(event);
        }
        
        /**
         * @private
         */
        private function removeLoaderEventListeners():void
        {
            _loader.removeEventListener(Event.COMPLETE, handleLoaderComplete);
            _loader.removeEventListener(IOErrorEvent.IO_ERROR, handleLoaderError);
            _loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleLoaderError);
        }
        
        /**
         * @private
         */
        private function stopTimer():void
        {
            if (_tim)
            {
                _tim.stop();
            }
        }
        
        /**
         * @private
         */
        protected function handleError(event:Event):void
        {
            if (event is ErrorEvent)
            {
                dispatchEvent(event);
            }
            else
            {
                dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
            }
        }
        
        /**
         * @private
         */
        protected function handleComplete(event:Event):void
        {
            dispatchEvent(new Event(Event.COMPLETE));
        }
    }
}