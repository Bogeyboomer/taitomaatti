# Kalenteri ja tapahtumahallinta React

Kalenterinäkymä ja tapahtumaeditori React-sovellukseen. Kaksi strategiaa: react-big-calendar (kaikki näkymät) tai shadcn/ui DatePicker (kevyt lomakekäyttö).

## Strategia A — react-big-calendar (täysi kalenteri)

```bash
npm install react-big-calendar date-fns
npm install -D @types/react-big-calendar
```

### Perusasennus

```typescript
import { Calendar, dateFnsLocalizer } from 'react-big-calendar'
import { format, parse, startOfWeek, getDay } from 'date-fns'
import { fi } from 'date-fns/locale'
import 'react-big-calendar/lib/css/react-big-calendar.css'

const localizer = dateFnsLocalizer({ format, parse, startOfWeek, getDay, locales: { fi } })

interface CalendarEvent {
  id: string
  title: string
  start: Date
  end: Date
  type: 'practice' | 'homeGame' | 'awayGame' | 'tournament' | 'camp' | 'trip'
  allDay?: boolean
}

function EventCalendar({ events }: { events: CalendarEvent[] }) {
  return (
    <Calendar
      localizer={localizer}
      events={events}
      startAccessor="start"
      endAccessor="end"
      style={{ height: 600 }}
      culture="fi"
      messages={{
        today: 'Tänään', next: '›', previous: '‹',
        month: 'Kuukausi', week: 'Viikko', day: 'Päivä', agenda: 'Agenda',
      }}
    />
  )
}
```

## Strategia B — shadcn/ui DatePicker (lomakekäyttöön)

```bash
npx shadcn@latest add calendar popover button
```

```typescript
import { Calendar } from '@/components/ui/calendar'
import { Popover, PopoverContent, PopoverTrigger } from '@/components/ui/popover'
import { format } from 'date-fns'
import { fi } from 'date-fns/locale'

function DatePickerField({ value, onChange }: { value?: Date; onChange: (d: Date) => void }) {
  return (
    <Popover>
      <PopoverTrigger asChild>
        <Button variant="outline">
          {value ? format(value, 'dd.MM.yyyy', { locale: fi }) : 'Valitse päivämäärä'}
        </Button>
      </PopoverTrigger>
      <PopoverContent>
        <Calendar mode="single" selected={value} onSelect={d => d && onChange(d)} locale={fi} />
      </PopoverContent>
    </Popover>
  )
}
```

## Tapahtumatyyppikohtaiset kentät

```typescript
type EventType = 'practice' | 'homeGame' | 'awayGame' | 'tournament' | 'camp' | 'trip' | 'other'

function ConditionalEventFields({ type }: { type: EventType }) {
  if (type === 'homeGame' || type === 'awayGame') {
    return <OpponentField label={type === 'homeGame' ? 'Vastustaja (kotipeli)' : 'Vastustaja (vieraspeli)'} />
  }
  if (type === 'tournament' || type === 'camp' || type === 'trip') {
    return (
      <>
        <DateRangeField startLabel="Lähtöpäivä" endLabel="Saapumispäivä" />
        <TimeField label="Lähtöaika" />
        <AddressField label="Lähtöosoite" />
      </>
    )
  }
  return <TitleField />
}
```

## Läsnäolokutsu (ole paikalla)

```typescript
const ARRIVAL_OPTIONS = [
  { value: 30, label: '30 min ennen' },
  { value: 60, label: '1 tunti ennen' },
  { value: 90, label: '1,5 tuntia ennen' },
  { value: 120, label: '2 tuntia ennen' },
]

function ArrivalSelector({ eventTime }: { eventTime: Date }) {
  const [minutesBefore, setMinutesBefore] = useState(60)
  const arrivalTime = new Date(eventTime.getTime() - minutesBefore * 60000)
  return (
    <div>
      <select value={minutesBefore} onChange={e => setMinutesBefore(Number(e.target.value))}>
        {ARRIVAL_OPTIONS.map(o => <option key={o.value} value={o.value}>{o.label}</option>)}
      </select>
      <span>Ole paikalla klo {format(arrivalTime, 'HH:mm')}</span>
    </div>
  )
}
```

## Avainperiaatteet

- **react-big-calendar** kuukausi/viikko/päivänäkymiin — `dateFnsLocalizer` + date-fns/locale fi
- **shadcn Calendar** lomakekäyttöön — ei ylimääräistä asennusta, Tailwind-yhteensopiva
- **date-fns fi-locale** — suomalainen muotoilu (`dd.MM.yyyy`, `HH:mm`) automaattisesti
- **Ehdolliset kentät** — renderöi EventType-perusteella, pitää logiikka yhdessä paikassa
- **Koko päivän tapahtumat** — `allDay: true` + `start.toDateString() === end.toDateString()`
- **Aikaväli vs. yksittäinen päivä** — turnaus/leiri/matka tarvitsevat DateRange, harjoitukset vain alkuajan
