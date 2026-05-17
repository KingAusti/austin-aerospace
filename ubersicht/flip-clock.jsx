// ─────────────────────────────────────────────────────────────────────────
//  Deep Forest Gruvbox — Split-Flap Flip Clock
//  Übersicht widget  |  bottom-right desktop  |  updates every second
//
//  Aesthetic: amber (#fabd2f) digits on dark felt (#3c3836) cards,
//  hairline centre divider, subtle vacuum-tube amber glow.
//  Font: VictorMono NFM
// ─────────────────────────────────────────────────────────────────────────

export const refreshFrequency = 1000; // ms

export const command = "date '+%H %M %S'";

// ── Palette (mirrors Gruvbox Dark Hard) ──────────────────────────────────
const C = {
  felt:    '#3c3836',  // BG1 — card face
  feltTop: '#2a2623',  // slightly darker for top-half shadow
  bg:      '#1d2021',  // BG Hard — divider line, widget backdrop
  amber:   '#fabd2f',  // Yellow — digits
  gray:    '#928374',  // Gray   — card labels
  glow:    'rgba(250, 189, 47, 0.55)',
  glowSm:  'rgba(250, 189, 47, 0.20)',
  shadow:  'rgba(0, 0, 0, 0.75)',
};

// ── Widget container (fixed bottom-right) ────────────────────────────────
export const className = `
  position: fixed;
  bottom: 32px;
  right: 32px;
  font-family: 'VictorMono NFM', 'Victor Mono', monospace;
  user-select: none;
  -webkit-user-select: none;
  pointer-events: none;
`;

// ── Sub-components ───────────────────────────────────────────────────────

function DigitCard({ digit }) {
  const card = {
    position: 'relative',
    width: '54px',
    height: '78px',
    borderRadius: '6px',
    overflow: 'hidden',
    margin: '0 2px',
    boxShadow: `0 0 14px ${C.glowSm}, 0 6px 20px ${C.shadow}`,
  };

  const half = {
    position: 'absolute',
    left: 0,
    right: 0,
    height: '50%',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    overflow: 'hidden',
  };

  const topHalf = {
    ...half,
    top: 0,
    background: C.feltTop,
    alignItems: 'flex-end',
    paddingBottom: '1px',
  };

  const bottomHalf = {
    ...half,
    bottom: 0,
    background: C.felt,
    alignItems: 'flex-start',
    paddingTop: '1px',
  };

  // Shared digit styling — each half clips its own portion
  const digitCommon = {
    fontSize: '52px',
    fontWeight: '700',
    lineHeight: '78px',   // full card height so both halves show the same char centred
    height: '78px',
    color: C.amber,
    textShadow: `0 0 18px ${C.glow}, 0 0 6px ${C.glowSm}`,
    position: 'absolute',
  };

  // Top half shows upper portion (digit shifted so its midpoint sits at card top)
  const digitTop = { ...digitCommon, top: 0 };
  // Bottom half mirrors: digit sits with its midpoint at card bottom
  const digitBottom = { ...digitCommon, top: '-39px' };   // shift up by half card height

  const divider = {
    position: 'absolute',
    left: 0,
    right: 0,
    top: '50%',
    transform: 'translateY(-50%)',
    height: '2px',
    background: C.bg,
    zIndex: 4,
    boxShadow: `0 1px 4px ${C.shadow}`,
  };

  return (
    <div style={card}>
      <div style={topHalf}>
        <span style={digitTop}>{digit}</span>
      </div>
      <div style={divider} />
      <div style={bottomHalf}>
        <span style={digitBottom}>{digit}</span>
      </div>
    </div>
  );
}

function TimeGroup({ value, label }) {
  const [tens, units] = String(value).padStart(2, '0').split('');
  return (
    <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '7px' }}>
      <div style={{ display: 'flex' }}>
        <DigitCard digit={tens} />
        <DigitCard digit={units} />
      </div>
      <span style={{
        fontSize: '9px',
        letterSpacing: '3.5px',
        color: C.gray,
        fontWeight: '600',
        textTransform: 'uppercase',
        marginRight: '-3.5px', /* compensate for letter-spacing on last char */
      }}>
        {label}
      </span>
    </div>
  );
}

function Colon() {
  return (
    <div style={{
      fontSize: '44px',
      fontWeight: '700',
      color: C.amber,
      opacity: 0.55,
      margin: '0 3px',
      marginBottom: '20px',  /* align with digit midpoint, above label area */
      lineHeight: '78px',
      textShadow: `0 0 12px ${C.glow}`,
    }}>:</div>
  );
}

// ── Main render ──────────────────────────────────────────────────────────
export const render = ({ output, error }) => {
  if (error) {
    return <div style={{ color: C.amber, fontSize: '11px' }}>clock error</div>;
  }

  const parts = (output || '00 00 00').trim().split(/\s+/);
  const [hh, mm, ss] = parts.map(p => p.padStart(2, '0'));

  return (
    <div style={{
      display: 'inline-flex',
      alignItems: 'center',
      padding: '14px 20px 16px',
      background: 'rgba(29, 32, 33, 0.82)',
      borderRadius: '14px',
      border: '1px solid rgba(60, 56, 54, 0.5)',
      backdropFilter: 'blur(24px)',
      WebkitBackdropFilter: 'blur(24px)',
      boxShadow: [
        `0 12px 40px ${C.shadow}`,
        `0 0 0 1px rgba(250,189,47,0.06)`,
        `inset 0 1px 0 rgba(255,255,255,0.04)`,
      ].join(', '),
      gap: '2px',
    }}>
      <TimeGroup value={hh} label="hrs" />
      <Colon />
      <TimeGroup value={mm} label="min" />
      <Colon />
      <TimeGroup value={ss} label="sec" />
    </div>
  );
};
