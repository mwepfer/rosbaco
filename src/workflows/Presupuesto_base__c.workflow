<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Aprobar_presupuesto</fullName>
        <field>Estado__c</field>
        <literalValue>Aprobado</literalValue>
        <name>Aprobar presupuesto</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Enviar_a_aprobacion</fullName>
        <field>Estado__c</field>
        <literalValue>Para aprobar</literalValue>
        <name>Enviar a aprobacion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rechazar_presupuesto</fullName>
        <field>Estado__c</field>
        <literalValue>Rechazado</literalValue>
        <name>Rechazar presupuesto</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Renegociar</fullName>
        <field>Estado__c</field>
        <literalValue>Renegociar</literalValue>
        <name>Renegociar</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
