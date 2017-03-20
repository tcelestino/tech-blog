window.ga = window.ga || function(){
  (ga.q = ga.q || []).push(arguments);
};

ga('create', 'UA-3692628-29', 'auto', 'prod');
ga('create', 'UA-3692628-30', 'auto', 'test');

ga('set', 'transport', 'beacon');
ga('send', 'pageview');

var dimensions = {
  CLIENT_ID: 'dimension1'
};

var metrics = {
  RESPONSE_END_TIME: 'metric1',
  DOM_LOAD_TIME: 'metric2',
  WINDOW_LOAD_TIME: 'metric3',
};

ga(function(tracker) {
  var clientId = tracker.get('clientId');
  tracker.set(dimensions.CLIENT_ID, clientId);
});

var trackError = function(error, fieldsObj) {
  ga('send', 'event', Object.assign({
    eventCategory: 'Script',
    eventAction: 'error',
    eventLabel: (error && error.stack) || '(not set)',
    nonInteraction: true,
  }, fieldsObj));
};

var loadErrorEvents = window.__e && window.__e.q || [],
    fieldsObj = { eventAction: 'uncaught error' };

for (var event of loadErrorEvents) {
  trackError(event.error, fieldsObj);
}

window.addEventListener('error', function(event) {
  trackError(event.error, fieldsObj);
});

var sendNavigationTimingMetrics = function() {
  if (!(window.performance && window.performance.timing)) return;

  if (document.readyState != 'complete') {
    window.addEventListener('load', sendNavigationTimingMetrics);
    return;
  }
  var performanceTiming = performance.timing,
      navStart = performanceTiming.navigationStart,
      responseEnd = Math.round(performanceTiming.responseEnd - navStart),
      domLoaded = Math.round(performanceTiming.domContentLoadedEventStart - navStart),
      windowLoaded = Math.round(performanceTiming.loadEventStart - navStart);

  var valuesIsValid = function(value) {
    return value > 0 && value < 1e6;
  };

  if (valuesIsValid(responseEnd) && valuesIsValid(domLoaded) && valuesIsValid(windowLoaded)) {
    ga('send', 'event', {
      eventCategory: 'Navigation Timing',
      eventAction: 'track',
      nonInteraction: true,
      [metrics.RESPONSE_END_TIME]: responseEnd,
      [metrics.DOM_LOAD_TIME]: domLoaded,
      [metrics.WINDOW_LOAD_TIME]: windowLoaded,
    });
  }
};

sendNavigationTimingMetrics();
