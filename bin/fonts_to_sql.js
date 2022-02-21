const fs = require('fs');
const readline = require('readline');

const glob = require('fast-glob');
const opentype = require('opentype.js');
const { optimize } = require('svgo');


/**
 *
 */
async function main() {
  process.chdir(__dirname + '/..');

  const sql = [];

  const fileStream = fs.createReadStream('data/font_order.txt');

  const rl = readline.createInterface({ input: fileStream });

  const all_glyphs = [];

  for await (const line of rl) {
    if (line.charAt(0) === '#') {
      continue;
    } else if (line === '!EMOJIS') {
      const [emoji_glyphs, emoji_images] = getEmojis(all_glyphs);
      all_glyphs.splice(-1, 0, ...emoji_glyphs);
      sql.splice(-1, 0, ...emoji_images);
      continue;
    } else if (line === '!CJK') {
      const [cjk_glyphs, cjk_images] = getCJK(all_glyphs);
      all_glyphs.splice(-1, 0, ...cjk_glyphs);
      sql.splice(-1, 0, ...cjk_images);
      continue;
    }
    const font = await getFont(line);
    if (! font) {
      process.exit(1);
    }
    for(let i = 0; i < font.glyphs.length; i++) {
      const glyph = font.glyphs.get(i);
      if (! glyph.unicode || all_glyphs.indexOf(glyph.unicode) > -1) {
        continue;
      }
      all_glyphs.push(glyph.unicode);
      sql.push(getImage(glyph, font));
    }
  }

  process.stdout.write('INSERT INTO codepoint_image ( cp, font, width, height, image ) VALUES\n');
  process.stdout.write(sql.join(',\n'));
  process.stdout.write(';');
}

/**
 *
 */
async function getFont(filename) {
  try {
    const stat = await fs.promises.lstat(filename);
    if (! stat.isFile()) {
      throw new Exception('not a file');
    }
  } catch (e) {
    console.error('file not found: '+filename);
    return null;
  }

  try {
    return await opentype.load(filename);
  } catch (err) {
    console.error(err);
    return null;
  }
}

/**
 *
 */
function getImage(glyph, font) {
  const hex = Number(glyph.unicode).toString(16).toUpperCase().padStart(4, '0');
  const width = glyph.advanceWidth || font.unitsPerEm;
  const height = font.unitsPerEm; //Math.abs(font.descender) + font.ascender;
  /* when the glyph has no advanceWidth, then it's some kind of
   * modifier. Move it into the middle of the canvas to make it
   * wholy visible. */
  const tr = glyph.advanceWidth? 0 : font.unitsPerEm / 2;
  return `( ${glyph.unicode}, '${font.names.fontFamily.en}', ${width}, ${height}, '<svg id="U${hex}" viewBox="0 0 ${width} ${height}">${glyph.path.toSVG().replace('<path ', `<path transform="translate(${tr}, ${font.unitsPerEm*0.9}) scale(1,-1)" `)}</svg>' )`;
}

/**
 *
 */
function getEmojis(handled_glyphs) {
  const sourcePath = 'cache/noto/emoji';
  const glyphs = [];
  const images = [];
  const sources = glob.sync('emoji_u*.svg', { cwd: sourcePath });
  for (const source of sources) {
    if (! /emoji_u([0-9a-f]+)\.svg$/.test(source)) {
      continue;
    }
    const hex = RegExp.$1.toUpperCase();
    const dec = parseInt(hex, 16);
    if (isNaN(dec)) {
      console.error(`problem with emoji ${source}`);
      continue;
    }
    if (dec < 255) {
      /* no ASCII emojis! */
      continue;
    }
    if (handled_glyphs.indexOf(dec) > -1) {
      console.error(`emoji ${source} already handled`);
      continue;
    }
    let content = fs.readFileSync(sourcePath + '/' + source);
    content = optimize(content, {
      multipass: true,
    }).data;
    content = content.replace(/ enable-background="[^"]*"/g, '');
    content = content.replace(/ style="enable-background:[^";]*;?"/g, '');
    content = content.replace(/id="/g, `id="U${hex}-`);
    content = content.replace(/url\(#/g, `url(#U${hex}-`);
    content = content.replace(/href="#/g, `href="#U${hex}-`);
    content = content.replace('<svg', `<svg id="U${hex}"`);
    let width = 128
    let height = 128
    let dimensions = /<svg[^>]* viewBox="(-?[0-9]+) (-?[0-9]+) (-?[0-9]+) (-?[0-9]+)"/.exec(content);
    if (dimensions) {
        width = Number(dimensions[3]) - Number(dimensions[1]);
        height = Number(dimensions[4]) - Number(dimensions[2]);
    }
    glyphs.push(dec);
    images.push(`( ${dec}, 'Noto Emoji', ${width}, ${height}, '${content.replace(/'/g, "''")}' )`);
  }
  return [glyphs, images];
}

/**
 *
 */
function getCJK() {
  const sources = {
    hk: 'cache/noto/NotoSansCJKhk-Regular.otf',
    jp: 'cache/noto/NotoSansCJKjp-Regular.otf',
    kr: 'cache/noto/NotoSansCJKkr-Regular.otf',
    sc: 'cache/noto/NotoSansCJKsc-Regular.otf',
    tc: 'cache/noto/NotoSansCJKtc-Regular.otf',
  }
  const images = [];
  const glyphs = [];
  const image_map = {};
  for (const id of sources) {
    const font = getFont(sources[id]);
    // TODO
  }
  return [glyphs, images];
}

main();
