// ------------------------------------------------------------
// MODELO DE COMPRAS
// Solo funciones SQL, limpias y ordenadas
// ------------------------------------------------------------

const db = require("../config/db");

// ------------------------------------------------------------
// 1. INSERTAR ENTREGA
// ------------------------------------------------------------
async function insertarEntrega(conn, direccion, costo) {
  const sql = `
    INSERT INTO entregas (direccion_entrega, costo_entrega, fecha_entrega)
    VALUES (?, ?, CURRENT_DATE)
  `;
  const [res] = await conn.query(sql, [direccion, costo]);
  return res.insertId;
}

// ------------------------------------------------------------
// 2. INSERTAR PEDIDO
// ------------------------------------------------------------
async function insertarPedido(conn, clienteId, entregaId, totalPedido) {
  const sql = `
    INSERT INTO pedidos (cliente_id_pedido, entrega_id_pedido, total_pedido)
    VALUES (?, ?, ?)
  `;
  const [res] = await conn.query(sql, [clienteId, entregaId, totalPedido]);
  return res.insertId;
}

// ------------------------------------------------------------
// 3. OBTENER PRODUCTO CON BLOQUEO FOR UPDATE
// ------------------------------------------------------------
async function obtenerProductoForUpdate(conn, productoId) {
  const sql = `
    SELECT id_producto, stock_producto, precio_producto
    FROM productos
    WHERE id_producto = ?
    FOR UPDATE
  `;
  const [rows] = await conn.query(sql, [productoId]);
  return rows[0] || null;
}

// ------------------------------------------------------------
// 4. INSERTAR DETALLE DE PEDIDO
// ------------------------------------------------------------
async function insertarDetallePedido(conn, pedidoId, productoId, cantidad, precio) {
  const sql = `
    INSERT INTO pedido_detalle (pedido_id, producto_id, cantidad, precio_unitario)
    VALUES (?, ?, ?, ?)
  `;
  await conn.query(sql, [pedidoId, productoId, cantidad, precio]);
}

// ------------------------------------------------------------
// 5. DESCONTAR STOCK
// ------------------------------------------------------------
async function descontarStock(conn, productoId, cantidad) {
  const sql = `
    UPDATE productos
    SET stock_producto = stock_producto - ?
    WHERE id_producto = ?
  `;
  await conn.query(sql, [cantidad, productoId]);
}

// ------------------------------------------------------------
// 6. CREAR VENTA
// ------------------------------------------------------------
async function crearVenta(conn, empleadoId, total) {
  const sql = `
    INSERT INTO ventas (empleado_id_venta, total_venta)
    VALUES (?, ?)
  `;
  const [res] = await conn.query(sql, [empleadoId, total]);
  return res.insertId;
}

// ------------------------------------------------------------
// 7. CREAR FACTURA
// ------------------------------------------------------------
async function crearFactura(conn, ventaId, pedidoId, subtotal, total) {
  const sql = `
    INSERT INTO facturas (venta_id_factura, pedido_id_factura, subtotal_factura, total_factura)
    VALUES (?, ?, ?, ?)
  `;
  const [res] = await conn.query(sql, [ventaId, pedidoId, subtotal, total]);
  return res.insertId;
}

// ------------------------------------------------------------
// EXPORTAR TODO
// ------------------------------------------------------------
module.exports = {
  insertarEntrega,
  insertarPedido,
  obtenerProductoForUpdate,
  insertarDetallePedido,
  descontarStock,
  crearVenta,
  crearFactura
};
