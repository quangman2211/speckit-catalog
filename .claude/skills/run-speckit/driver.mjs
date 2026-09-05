#!/usr/bin/env node
// Driver cho he thong Spec-Driven Development dung chung.
// Project dich mac dinh la thu muc dang dung (cwd).
// Xem .claude/skills/run-speckit/SKILL.md
//
//   node .claude/skills/run-speckit/driver.mjs <doctor|build|e2e|gate|all>
//   node .claude/skills/run-speckit/driver.mjs <cmd> [project-dir]
//
// Thoat 0 khi moi check pass, 1 khi co check that bai, 2 khi thieu tien de.

import { execFileSync, spawn } from 'node:child_process';
import { existsSync, readdirSync, readFileSync, mkdtempSync, rmSync } from 'node:fs';
import { join, resolve, dirname, extname } from 'node:path';
import { tmpdir } from 'node:os';
import { fileURLToPath } from 'node:url';

// Skill nay song trong repo speckit-catalog va duoc dung lai boi nhieu project
// (thuong qua symlink .claude/skills/run-speckit trong tung project). Node resolve
// symlink truoc khi dat import.meta.url, nen SKILL_DIR luon la duong dan that
// trong speckit-catalog du goi qua symlink nao.
const SKILL_DIR = dirname(fileURLToPath(import.meta.url));
const PORT = Number(process.env.SPECKIT_CATALOG_PORT || 8777);
const CATALOG_URL = `http://localhost:${PORT}/catalog.json`;
const ZIP_BASE_URL = `http://localhost:${PORT}/dist`;

// Repo catalog = 3 cap tren skill dir. Van cho phep ghi de bang bien moi truong.
const CATALOG_DIR = (() => {
  const candidates = [
    process.env.SPECKIT_CATALOG_DIR,
    resolve(SKILL_DIR, '..', '..', '..'),
  ].filter(Boolean);
  for (const c of candidates) if (existsSync(join(c, 'scripts', 'build.sh'))) return c;
  return null;
})();

// Project dich: doi so thu 2, roi bien moi truong, roi thu muc dang dung.
// Khong con suy ra tu vi tri skill nua — skill dung chung cho moi project.
const PROJECT = resolve(process.argv[3] || process.env.SPECKIT_PROJECT || process.cwd());

// specify duoc cai bang `uv tool install`; ~/.local/bin khong phai luc nao cung
// nam trong PATH cua tien trinh con.
const SPECIFY = (() => {
  for (const c of ['specify', join(process.env.HOME, '.local', 'bin', 'specify')]) {
    try { execFileSync(c, ['--version'], { stdio: 'ignore' }); return c; } catch {}
  }
  console.error('FATAL: khong tim thay `specify`.\n  uv tool install specify-cli --from git+https://github.com/github/spec-kit.git');
  process.exit(2);
})();

let failures = 0;
const ok   = (m) => console.log(`  \x1b[32mPASS\x1b[0m  ${m}`);
const bad  = (m, d) => { failures++; console.log(`  \x1b[31mFAIL\x1b[0m  ${m}${d ? `\n        ${String(d).trim().split('\n').slice(0, 4).join('\n        ')}` : ''}`); };
const note = (m) => console.log(`  \x1b[90m....\x1b[0m  ${m}`);
const head = (m) => console.log(`\n\x1b[1m${m}\x1b[0m`);

function run(cmd, args, opts = {}) {
  try {
    return { code: 0, out: execFileSync(cmd, args, { encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'], ...opts }) };
  } catch (e) {
    return { code: e.status ?? 1, out: `${e.stdout || ''}${e.stderr || ''}` };
  }
}
const spec = (args, opts) => run(SPECIFY, args, opts);

function check(label, fn) {
  try {
    const r = fn();
    if (r === true || r === undefined) ok(label); else bad(label, r);
  } catch (e) { bad(label, e.message); }
}

function requireCatalog() {
  if (CATALOG_DIR) return CATALOG_DIR;
  console.error('FATAL: khong tim thay repo speckit-catalog.\n' +
    '  Clone canh Retail-OPS, hoac dat SPECKIT_CATALOG_DIR=<duong-dan>');
  process.exit(2);
}

// Build/serve luon chay tren BAN SAO tam, khong bao gio ghi de catalog.json
// da commit trong repo speckit-catalog (build.sh ghi URL localhost vao do).
let STAGE = null;
function stageCatalog() {
  const src = requireCatalog();
  STAGE = mkdtempSync(join(tmpdir(), 'speckit-stage-'));
  execFileSync('cp', ['-R', `${src}/.`, STAGE]);
  rmSync(join(STAGE, '.git'), { recursive: true, force: true });
  rmSync(join(STAGE, 'dist'), { recursive: true, force: true });
  return STAGE;
}

// ---------------------------------------------------------------- doctor
function requireProject() {
  if (existsSync(join(PROJECT, '.specify'))) return true;
  console.error(
    `\nFATAL: '${PROJECT}' khong phai spec-kit project (thieu .specify/).\n` +
    `  cd vao project roi chay lai, hoac truyen duong dan:\n` +
    `    node <driver> ${process.argv[2] || 'all'} /duong/dan/toi/project`);
  process.exit(2);
}

function doctor() {
  head(`doctor — toolchain va cau truc: ${PROJECT}`);

  check('specify CLI chay duoc', () => {
    const r = spec(['--version']);
    if (r.code !== 0) return r.out;
    note(r.out.trim().split('\n').pop());
  });

  for (const p of ['.specify', '.specify/memory/constitution.md', '.specify/templates', '.claude/skills'])
    check(`ton tai ${p}`, () => existsSync(join(PROJECT, p)) || `thieu ${p}`);

  check('extensions git + agent-context da cai', () => {
    const r = spec(['extension', 'list'], { cwd: PROJECT });
    if (r.code !== 0) return r.out;
    const missing = ['Git Branching', 'Coding Agent Context'].filter((n) => !r.out.includes(n));
    return missing.length === 0 || `thieu: ${missing.join(', ')}`;
  });

  check('skills speckit da dang ky cho Claude Code', () => {
    const dir = join(PROJECT, '.claude', 'skills');
    if (!existsSync(dir)) return 'khong co .claude/skills';
    const skills = readdirSync(dir).filter((d) => d.startsWith('speckit-'));
    note(`${skills.length} skill`);
    return skills.length >= 16 || `chi co ${skills.length} skill, mong doi >= 16`;
  });

  check('tim thay repo speckit-catalog', () => {
    if (!CATALOG_DIR) return 'khong thay — clone canh Retail-OPS hoac dat SPECKIT_CATALOG_DIR';
    note(CATALOG_DIR);
  });
}

// ---------------------------------------------------------------- build
function build() {
  head('build — dong goi extension va bundle tren ban sao tam');
  note(`staging: ${STAGE}`);

  check('scripts/build.sh chay thanh cong', () => {
    const r = run('bash', [join(STAGE, 'scripts', 'build.sh'), ZIP_BASE_URL, CATALOG_URL]);
    if (r.code !== 0) return r.out;
    r.out.trim().split('\n').forEach(note);
  });

  check('catalog.json hop le', () => {
    const p = join(STAGE, 'catalog.json');
    if (!existsSync(p)) return 'chua sinh catalog.json';
    const ids = Object.keys(JSON.parse(readFileSync(p, 'utf8')).extensions || {});
    note(`extensions: ${ids.join(', ') || '(rong)'}`);
    return ids.length > 0 || 'catalog khong co extension nao';
  });

  check('artifact extension + bundle da sinh', () => {
    const dist = join(STAGE, 'dist');
    if (!existsSync(dist)) return 'thieu dist/';
    const zips = readdirSync(dist).filter((f) => f.endsWith('.zip'));
    note(zips.join(', '));
    return zips.length >= 2 || `mong doi >=2 zip (extension + bundle), co ${zips.length}`;
  });
}

// ---------------------------------------------------------------- e2e
async function serveCatalog() {
  const srv = spawn('python3', ['-m', 'http.server', String(PORT), '--directory', STAGE], { stdio: 'ignore' });
  for (let i = 0; i < 40; i++) {
    await new Promise((r) => setTimeout(r, 150));
    try { if ((await fetch(`http://localhost:${PORT}/`)).ok) return srv; } catch {}
  }
  srv.kill();
  throw new Error(`catalog server khong len duoc tren cong ${PORT} (cong da bi chiem?)`);
}

async function e2e() {
  head('e2e — cai catalog + bundle tren project TRANG');
  note('phai dung project trang: neu extension da cai san, bundle install se skip va che giau loi catalog');

  const art = join(STAGE, 'dist', 'retail-frontend-1.0.0.zip');
  if (!existsSync(art)) { bad('bundle artifact ton tai', 'chua build — chay `build` truoc `e2e`'); return; }

  let tmp;
  try {
    tmp = mkdtempSync(join(tmpdir(), 'speckit-e2e-'));
    const at = { cwd: tmp };

    check('specify init tren thu muc trang', () => {
      const r = spec(['init', '--here', '--force', '--non-interactive', '--integration', 'claude'], at);
      return r.code === 0 || r.out;
    });

    check('bundle install THIEU catalog phai bao loi', () => {
      const r = spec(['bundle', 'install', art], at);
      if (r.code === 0) return 'install THANH CONG khi chua co catalog — sai, phai that bai';
      return /not found in any catalog/.test(r.out) || `bao loi khac mong doi:\n${r.out}`;
    });

    check('dang ky catalog noi bo', () => {
      const r = spec(['extension', 'catalog', 'add', CATALOG_URL,
        '--name', 'quangman', '--priority', '1', '--install-allowed'], at);
      return r.code === 0 || r.out;
    });

    check('bundle install thanh cong sau khi co catalog', () => {
      const r = spec(['bundle', 'install', art], at);
      if (r.code !== 0) return r.out;
      note(r.out.trim().split('\n').pop());
    });

    check('ca 3 extension co mat sau install', () => {
      const r = spec(['extension', 'list'], at);
      const missing = ['Git Branching', 'Coding Agent Context', 'Frontend Workflow']
        .filter((n) => !r.out.includes(n));
      return missing.length === 0 || `thieu: ${missing.join(', ')}`;
    });

    check('skill frontend duoc dang ky cho Claude Code', () => {
      const have = readdirSync(join(tmp, '.claude', 'skills')).filter((d) => d.startsWith('speckit-frontend-'));
      note(have.join(', '));
      return have.length === 2 || `mong doi 2 skill frontend, co ${have.length}`;
    });

    check('token __SPECKIT_COMMAND_*__ da render thanh /speckit-*', () => {
      const body = readFileSync(join(tmp, '.claude', 'skills', 'speckit-frontend-a11y', 'SKILL.md'), 'utf8');
      if (body.includes('__SPECKIT_COMMAND_')) return 'con token chua render trong SKILL.md';
      return /\/speckit-implement/.test(body) || 'khong thay /speckit-implement sau khi render';
    });
  } finally {
    if (tmp) rmSync(tmp, { recursive: true, force: true });
  }
}


// ---------------------------------------------------------------- update
// Cap nhat extension tu catalog noi bo vao mot project. Mac dinh la Retail-OPS;
// truyen duong dan de cap nhat project khac:
//   node .../driver.mjs update /duong/dan/toi/project
function update(target = PROJECT) {
  head(`update — cap nhat extension tu catalog vao ${target}`);
  const at = { cwd: target };

  if (!existsSync(join(target, '.specify'))) {
    bad('project dich hop le', `${target} khong phai spec-kit project (thieu .specify/)`);
    return;
  }

  const ids = Object.keys(JSON.parse(readFileSync(join(STAGE, 'catalog.json'), 'utf8')).extensions || {});
  note(`catalog cung cap: ${ids.join(', ')}`);

  // Dang ky catalog neu chua co (idempotent, loi trung ten bo qua duoc).
  spec(['extension', 'catalog', 'add', CATALOG_URL, '--name', 'quangman',
        '--priority', '1', '--install-allowed'], at);

  // Catalog duoc cache 3600s. Khong xoa thi `update` bao "Up to date" du
  // catalog da serve version moi.
  rmSync(join(target, '.specify', 'extensions', '.cache'), { recursive: true, force: true });
  note('da xoa .specify/extensions/.cache (TTL 1 gio)');

  const listed = spec(['extension', 'list'], at).out;
  const installed = (id) => new RegExp(`^\\s+${id}\\s*$`, 'm').test(listed);

  let touched = 0;
  for (const id of ids) {
    if (!installed(id)) { note(`${id}: chua cai trong project nay, bo qua`); continue; }
    touched++;
    check(`${id}: cai lai tu catalog`, () => {
      // `extension update` hoi [y/N] va khong co --yes, nen dung add --force:
      // khong can TTY, va config da tuy chinh van duoc giu.
      const r = spec(['extension', 'add', id, '--force'], at);
      if (r.code !== 0) return r.out;
      const v = r.out.match(/\(v(\d+\.\d+\.\d+)\)/);
      note(`${id} -> v${v ? v[1] : '?'}`);
      if (/Config files already exist \(preserved\)/.test(r.out)) note(`${id}: config tuy chinh duoc giu`);
    });
  }
  if (touched === 0) note('khong co extension nao cua catalog duoc cai o day — khong lam gi');
  else note('restart Claude Code de skill moi co hieu luc');
}

// ---------------------------------------------------------------- gate
const CODE_EXT = new Set(['.ts', '.tsx', '.js', '.jsx', '.mjs', '.cjs', '.py', '.go', '.rs', '.java', '.rb', '.php', '.svelte', '.vue']);
const SKIP_DIR = new Set(['.git', '.specify', '.claude', 'node_modules', 'speckit-catalog', 'dist', '.venv', '__pycache__']);

function appCode(dir, acc = []) {
  for (const e of readdirSync(dir, { withFileTypes: true })) {
    if (SKIP_DIR.has(e.name)) continue;
    const p = join(dir, e.name);
    if (e.isDirectory()) appCode(p, acc);
    else if (CODE_EXT.has(extname(e.name))) acc.push(p.slice(PROJECT.length + 1));
  }
  return acc;
}

function gate() {
  head('gate — "he thong truoc, code sau" (Constitution I & II)');
  const specsDir = join(PROJECT, 'specs');
  const specs = existsSync(specsDir)
    ? readdirSync(specsDir).filter((d) => existsSync(join(specsDir, d, 'spec.md')))
    : [];
  const code = appCode(PROJECT);
  note(`spec co san: ${specs.length ? specs.join(', ') : '(chua co)'}`);
  note(`file code ung dung: ${code.length}`);

  check('constitution da duoc viet (khong con placeholder)', () => {
    const p = join(PROJECT, '.specify', 'memory', 'constitution.md');
    if (!existsSync(p)) return 'thieu constitution.md';
    return !readFileSync(p, 'utf8').includes('[PROJECT_NAME]') || 'van con placeholder — chay /speckit-constitution';
  });

  check('khong co code ung dung khi chua co spec', () => {
    if (code.length === 0 || specs.length > 0) return true;
    return `co ${code.length} file code nhung chua co spec.md nao:\n${code.slice(0, 8).join('\n')}`;
  });
}

// ---------------------------------------------------------------- main
const cmd = process.argv[2] || 'all';

async function withStagedServer(fn) {
  stageCatalog();
  const srv = await serveCatalog();
  ok(`catalog server dang chay tai ${CATALOG_URL}`);
  try { return await fn(); }
  finally { srv.kill(); if (STAGE) rmSync(STAGE, { recursive: true, force: true }); }
}

try {
  if (cmd === 'all') {
    requireProject();
    doctor();
    await withStagedServer(async () => { build(); await e2e(); });
    gate();
  } else if (cmd === 'build' || cmd === 'e2e') {
    await withStagedServer(async () => { build(); if (cmd === 'e2e') await e2e(); });
  } else if (cmd === 'update') {
    requireProject();
    await withStagedServer(async () => { build(); update(PROJECT); });
  } else if (cmd === 'doctor') { requireProject(); doctor(); }
  else if (cmd === 'gate') { requireProject(); gate(); }
  else {
    console.error(`Lenh khong hop le: ${cmd}\nDung: doctor | build | e2e | gate | update [project] | all`);
    process.exit(2);
  }
} finally {
  if (STAGE && existsSync(STAGE)) rmSync(STAGE, { recursive: true, force: true });
}

console.log(failures === 0 ? `\n\x1b[32m✓ tat ca check pass\x1b[0m` : `\n\x1b[31m✗ ${failures} check that bai\x1b[0m`);
process.exit(failures === 0 ? 0 : 1);
