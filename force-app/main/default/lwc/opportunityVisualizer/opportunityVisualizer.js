import { api, LightningElement, track } from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import FullCalendarJS from '@salesforce/resourceUrl/FullCalendarJS';
import getOppo from '@salesforce/apex/oppoCloseDate.getOppo';

export default class OpportunityVisualizer extends LightningElement {
    @api item01;
    @api item02;
    @track returnedOppo = [] ;
    @track finalOppo = [] ;
  
    renderedCallback() {
        Promise.all([
            loadScript(this, FullCalendarJS + '/FullCalendarJS/jquery.min.js'),
            loadScript(this, FullCalendarJS + '/FullCalendarJS/moment.min.js'),
            loadScript(this, FullCalendarJS + '/FullCalendarJS/fullcalendar.min.js'),
            loadStyle(this, FullCalendarJS + '/FullCalendarJS/fullcalendar.min.css'),
            // loadStyle(this, FullCalendarJS + '/fullcalendar.print.min.css')
        ])
        .then(() => {
            // Initialise the calendar configuration
            this.getTasks();
            // this.initialiseFullCalendarJs();
        })
        .catch(error => {
            // eslint-disable-next-line no-console
            console.error({
            message: 'Not Loading FullCalendarJS',
            error
            });
        })
    }

    initialiseFullCalendarJs() {
/*         
    events.push({
        id: result[i].Id,
        title: result[i].Subject,
        start: result[i].StartDateTime,
        end: result[i].EndDateTime,
        color: '#50e3c1'
    });
*/
        for(var i = 0 ; i < this.returnedOppo.length ; i++){
            this.finalOppo.push({
                start : this.returnedOppo[i].CloseDate,
                title : this.returnedOppo[i].Name,
                // url : tDomain+'/lightning/r/Opportunity/'+this.returnedOppo[i].Id+'/view'
            });
        }
        const ele = this.template.querySelector('div.fullcalendarjs');
        // eslint-disable-next-line no-undef
        $(ele).fullCalendar({
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,basicWeek,basicDay'
            },
            // defaultDate: '2020-03-12',
            defaultDate: new Date(), // default day is today
            navLinks: true, // can click day/week names to navigate views
            editable: true,
            eventLimit: true, // allow "more" link when too many events
            events : this.finalOppo
        });
    }

    getTasks(){
        getOppo()
        .then(result =>{   
            this.returnedOppo = JSON.parse(result);
            this.initialiseFullCalendarJs();
            this.error = undefined;

            console.log('RESULT: '+ result);
            console.log('returnedOppo: '+ JSON.parse(result));
        })
        .catch(error => {
            this.error = error;
            this.outputResult = undefined;
            console.log('ERROR: '+ error.message);
        });
    }
}